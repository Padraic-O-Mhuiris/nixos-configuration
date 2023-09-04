{ lib, pkgs, ... }:

# Examples:
# https://github.com/raven2cz/polybar-config

(lib.os.applyHmUsers (user:
  { config, ... }:
  let
    colors = {
      background = config.lib.stylix.colors.withHashtag.base02;
      foreground = config.lib.stylix.colors.withHashtag.base05;
      sep = config.lib.stylix.colors.withHashtag.base06;

      white = config.lib.stylix.colors.withHashtag.base06;
      black = config.lib.stylix.colors.withHashtag.base00;
      red = config.lib.stylix.colors.withHashtag.base08;
      pink = config.lib.stylix.colors.withHashtag.base0E;
      purple = config.lib.stylix.colors.withHashtag.base0F;
      blue = config.lib.stylix.colors.withHashtag.base0D;
      cyan = config.lib.stylix.colors.withHashtag.base0C;
      teal = config.lib.stylix.colors.withHashtag.base07;
      green = config.lib.stylix.colors.withHashtag.base0B;
      yellow = config.lib.stylix.colors.withHashtag.base0A;
      orange = config.lib.stylix.colors.withHashtag.base09;
      gray = config.lib.stylix.colors.withHashtag.base04;
      blue-gray = config.lib.stylix.colors.withHashtag.base03;
    };

    fontVerticalOffset = 3;

    font-0 = "${config.stylix.fonts.monospace.name}:size=${
        toString config.lib.stylix.i3.bar.fonts.size
      };${toString fontVerticalOffset}";

    font-1 = "${config.stylix.fonts.monospace.name}:size=${
        toString (config.lib.stylix.i3.bar.fonts.size * 1.5)
      };${toString (fontVerticalOffset * 1.75)}";

    border-size = 25;

    bar.bottom = {
      enable-ipc = true;
      bottom = true;

      height = config.lib.stylix.i3.bar.fonts.size * 5.5;
      width = "100%";
      padding = 0;

      background = colors.background;
      foreground = colors.foreground;

      module-margin = 1;

      #radius = 15;

      fixed-center = true;
      override-redirect = true;

      # border-left-size = border-size;
      # border-left-color = colors.black;
      # border-right-size = border-size;
      # border-right-color = colors.black;
      # border-bottom-size = border-size;
      # border-bottom-color = colors.black;

      underline-size = 4;
      underline-color = colors.yellow;

      inherit font-0 font-1;

      dpi-x = 160; # TODO DPI
      dpi-y = 160; # TODO DPI

      tray-position = "right";
      tray-scale = 1;
      tray-padding = 5;
      tray-background = colors.background;
      tray-maxsize = config.lib.stylix.i3.bar.fonts.size * 4;
      tray-offset-x = 0;

      separator = "|";

      wm-restack = "i3";

    };

    module.home = {
      type = "custom/text";
      content = "%{T2}%{T-}";
      content-background = colors.white;
      content-foreground = colors.black;
      content-padding = 2;
    };

    module.i3 = {
      type = "internal/i3";
      pin-workspaces = true;
      show-urgent = true;
      enable-click = true;

      label-mode = "%mode%";
      label-mode-padding = 2;
      label-mode-background = colors.background;

      label-focused = "%index%";
      label-focused-foreground = colors.yellow;
      label-focused-background = colors.background;
      label-focused-underline = colors.yellow;
      label-focused-padding = 1;

      label-unfocused = "%index%";
      label-unfocused-padding = 1;

      label-visible = "%index%";
      label-visible-underline = colors.white;
      label-visible-padding = 1;

      label-urgent = "%index%";
      label-urgent-foreground = colors.black;
      label-urgent-background = colors.red;
      label-urgent-padding = 1;

      label-separator = "◦";
      label-separator-padding = 0;
      label-separator-foreground = colors.foreground;
    };

    module.date = {
      type = "internal/date";
      interval = 1;
      label = "%{T2}%{T-} %date%";
      format-foreground = colors.background;
      format-background = colors.white;
      format-padding = 1;
      date = "%H:%M";
      date-alt = "%A, %d %B %Y";
    };

    module.backlight = {
      type = "internal/backlight";
      format = "%{T2}<ramp>%{T-} <label>";
      enable-scroll = true;
      card = "intel_backlight";
      label = "%percentage%%";
      ramp-0 = "🌕";
      ramp-1 = "🌔";
      ramp-2 = "🌓";
      ramp-3 = "🌒";
      ramp-4 = "🌑";

      format-foreground = colors.foreground;
      format-background = colors.background;
      format-padding = 2;
    };

    module.battery = {
      type = "internal/battery";
      full-at = 99;
      low-at = 10;
      battery = "BAT0";
      adapter = "AC";
      poll-interval = 5;
      time-format = "%H:%M";

      format-charging =
        "%{F${colors.yellow}}%{T2}<animation-charging>%{T-} ◦ <label-charging>%{F-}";
      label-charging = "%time% ◦ %percentage_raw%% ";

      format-discharging =
        "%{F${colors.yellow}}%{T2}<ramp-capacity>%{T-} ◦ <label-discharging>%{F-}";
      label-discharging = "%time% ◦ %percentage_raw%%";

      format-full =
        "%{F${colors.green}}%{T2}<ramp-capacity>%{T-} ◦ <label-full>%{F-}";
      label-full = "%percentage_raw%%";

      format-low =
        "%{F${colors.red}}%{T2}<animation-low>%{T-} ◦ <label-low>%{F-}";
      label-low = "%time% ◦ %percentage_raw%%";

      ramp-capacity-0 = "";
      ramp-capacity-1 = "";
      ramp-capacity-2 = "";
      ramp-capacity-3 = "";
      ramp-capacity-4 = "";

      bar-capacity-width = 10;

      animation-charging-0 = "";
      animation-charging-1 = "";
      animation-charging-2 = "";
      animation-charging-3 = "";
      animation-charging-4 = "";
      animation-charging-framerate = 1000;

      animation-discharging-0 = "";
      animation-discharging-1 = "";
      animation-discharging-2 = "";
      animation-discharging-3 = "";
      animation-discharging-4 = "";
      animation-discharging-framerate = 1000;

      animation-low-0 = "";
      animation-low-1 = "";
      animation-low-framerate = 500;
    };

    module.wifi = {
      type = "internal/network";
      interface = "wlp0s20f3";
      interface-type = "wireless";
      interval = 1.0;
      accumulate-stats = true;

      format-connected = "<label-connected>";
      label-connected = "%local_ip% ◦ %essid%";
      label-connected-foreground = colors.green;
    };

    module.filesystem = {
      type = "internal/fs";
      mount-0 = "/";
      mount-1 = "/home";
      mount-2 = "/nix";
      interval = 10;
      fixed-values = true;
      spacing = 2;

      format-mounted = "<label-mounted>";
      label-mounted = "%{T2}%{T-} %mountpoint% %used%";
    };
  in {
    services.polybar = {
      enable = true;
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
      package = pkgs.polybarFull;
      settings = {
        "bar/bottom" = bar.bottom // {
          "modules-left" = "home i3 filesystem";
          "modules-right" = "backlight wifi battery date";
        };
        "module/i3" = module.i3;
        "module/home" = module.home;
        "module/date" = module.date;
        "module/backlight" = module.backlight;
        "module/battery" = module.battery;
        "module/wifi" = module.wifi;
        "module/filesystem" = module.filesystem;
        # "module/volume" = {
        #   type = "internal/pulseaudio";
        #   format.volume = "<ramp-volume> <label-volume>";
        #   label.muted.text = "🔇";
        #   label.muted.foreground = "#666";
        #   ramp.volume = [ "🔈" "🔉" "🔊" ];
        #   click.right = "pavucontrol &";
        # };
      };
    };
  }))
