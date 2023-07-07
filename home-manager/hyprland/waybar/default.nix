{ inputs, config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: rec {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    settings = {
      main = {
        layout = "top";
        height = 30;
        output = [ "DP-1" ];

        # layout
        modules-left = [ "wlr/workspaces" ];
        modules-center = [ "clock" "cpu" "temperature" "disk" "disk#nix" "disk#home" ];
        modules-right = [ "hyprland/window" "sndio" "bluetooth" "network" "tray"];

        cpu = {
          interval = 2;
          format = " | {icon} {avg_frequency} Ghz {usage}% ";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          max-length = 30;
        };

        temperature = {
          interval = 5;
          format = " | {temperatureC} °C ";
        };

        disk = {
          interval = 30;
          format = " | {used} / {total} | {percentage_used} %";
          path = "/";
        };

        "disk#home" = {
          interval = 30;
          format = " | {used} / {total} | {percentage_used} %";
          path = "/home";
        };

        "disk#nix" = {
          interval = 30;
          format = " | {used} / {total} | {percentage_used} %";
          path = "/nix/store";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };

sndio = {
    format = "{raw_value} 🎜";
    scroll-step = 3;
};
        tray = {
          icon-size = 15;
          spacing = 10;
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
          max-length = 50;
        };

        # clock
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y (%R)} ";
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          on-click = "activate";
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 1;
        font-family: Font Awesome, Iosevka, Arial, sans-serif;
        font-size: 13px;
        color: #000000;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #disk,
      #network,
      #pulseaudio,

      #custom-media,
      #tray,
      #mode,
      #custom-power,
      #custom-menu,
      #workspaces,
      #idle_inhibitor {
        padding: 0 20px;
      }

      #workspaces button.active {
        border-top: 3px solid red;
        border-bottom: 3px solid red;
      }
    '';
  };
}
