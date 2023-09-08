{ config, lib, pkgs, ... }:

{
  imports = [ ./modules/i3.nix ];
} // (lib.os.hm (user:
  { config, ... }: {
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
        "module/home" = module.home;
        # "module/date" = module.date;
        # "module/backlight" = module.backlight;
        # "module/battery" = module.battery;
        # "module/wifi" = module.wifi;
        # "module/filesystem" = module.filesystem;
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
