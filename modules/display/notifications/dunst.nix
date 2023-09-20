{ lib, pkgs, ... }:

lib.os.hm (_:
  ({ config, ... }:
    let inherit (config.stylix.fonts) sansSerif sizes;
    in {
      services.dunst = {
        enable = true;
        iconTheme = {
          name = "Adwaita";
          package = pkgs.gnome3.adwaita-icon-theme;
        };
        settings = {
          global = {
            monitor = 0;
            width = 400;
            height = 300;
            offset = "10x10";
            scale = 0;
            follow = "mouse";
            origin = "top-right";
            shrink = "yes";
            padding = 16;
            horizontal_padding = 16;
            font = "${sansSerif.name} ${toString sizes.applications}";
            separator_color = lib.os.colors.silver;
            line_height = 4;
            format = "<b>%s</b>\\n%b";
            corner_radius = 5;
            icon_corner_radius = 5;
            min_icon_size = 128;
            max_icon_size = 128;
          };

          urgency_low = {
            background = lib.os.colors.black;
            foreground = lib.os.colors.pearl;
            frame_color = lib.os.colors.green;
          };

          urgency_normal = {
            background = lib.os.colors.black;
            foreground = lib.os.colors.pearl;
            frame_color = lib.os.colors.yellow;
          };

          urgency_critical = {
            background = lib.os.colors.black;
            foreground = lib.os.colors.white;
            frame_color = lib.os.colors.red;
          };
        };
      };

    })) // {
      environment.systemPackages = with pkgs; [ libnotify dbus ];
    }
