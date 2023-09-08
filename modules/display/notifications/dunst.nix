{ lib, pkgs, ... }:

lib.os.hm (_:
  ({ config, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
      inherit (config.stylix.fonts) sansSerif sizes;
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
            # geometry = "800x50-50+65";
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
            separator_color = colors.base02;
            line_height = 4;
            format = "<b>%s</b>\\n%b";
            corner_radius = 5;
            icon_corner_radius = 5;
            min_icon_size = 128;
            max_icon_size = 128;
          };

          urgency_low = {
            background = colors.base01;
            foreground = colors.base05;
            frame_color = colors.base0B;
          };

          urgency_normal = {
            background = colors.base01;
            foreground = colors.base05;
            frame_color = colors.base0E;
          };

          urgency_critical = {
            background = colors.base01;
            foreground = colors.base05;
            frame_color = colors.base08;
          };
        };
      };

    })) // {
      environment.systemPackages = with pkgs; [ libnotify dbus ];
    }
