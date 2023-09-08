{ lib, pkgs, ... }:

{
  imports = [
    ./i3.nix
    ./filesystem.nix
    ./wifi.nix
    ./battery.nix
    ./date.nix
    ./home.nix
    ./backlight.nix
  ];
} // (lib.os.hm (user:
  { config, ... }:
  let
    colors = config.lib.stylix.colors.withHashtag;

    font-0 = "${config.stylix.fonts.monospace.name}:size=${
        toString config.lib.stylix.i3.bar.fonts.size
      };${toString fontVerticalOffset}";

    font-1 = "${config.stylix.fonts.monospace.name}:size=${
        toString (config.lib.stylix.i3.bar.fonts.size * 1.5)
      };${toString (fontVerticalOffset * 1.75)}";

    bar.bottom = {
      inherit font-0 font-1;
      height = config.lib.stylix.i3.bar.fonts.size;
      width = "100%";
      bottom = true;
      enable-ipc = true;
      padding = 0;
      background = colors.base01;
      foreground = colors.base06;
      module-margin = 1;
      #radius = 15;
      fixed-center = true;
      override-redirect = true;
      underline-size = 4;
      underline-color = colors.base0A;
      # dpi-x = 160; # TODO DPI
      # dpi-y = 160; # TODO DPI
      tray-position = "right";
      tray-scale = 1;
      tray-padding = 5;
      tray-background = colors.background;
      tray-maxsize = config.lib.stylix.i3.bar.fonts.size * 4;
      tray-offset-x = 0;
      separator = "|";
      wm-restack = "i3";
    };

    script = ''
      # Terminate already running bar instances
      # If all your bars have ipc enabled, you can use
      polybar-msg cmd quit
      # Otherwise you can use the nuclear option:
      # killall -q polybar

      # Launch bar1 and bar2
      echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
      polybar bottom 2>&1 | tee -a /tmp/polybar1.log & disown
      #polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

      echo "Bars launched..."
    '';

    settings = {
      "bar/bottom" = bar.bottom // {
        "modules-left" = "home i3 filesystem";
        "modules-right" = "backlight wifi battery date";
      };
    };
  in {
    services.polybar = {
      enable = true;
      package = pkgs.polybarFull;
      inherit script settings;
    };

    # Need to offset window gaps if polybar does not want to interact with
    xsession.windowManager.i3.config.gaps = {
      top = if config.services.polybar.settings."bar/top".override-redirect then
        40
      else
        null;
      bottom =
        if config.services.polybar.settings."bar/bottom".override-redirect then
          40
        else
          null;
    };
  }))
