{ lib, ... }:

(lib.os.hm (user:
  { config, ... }:
  let colors = config.lib.stylix.colors.withHashtag;
  in {
    services.polybar.settings."module/backlight" = {
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
  }))
