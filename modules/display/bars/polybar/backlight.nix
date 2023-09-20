{ lib, ... }:

(lib.os.hm (user: {
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

    format-foreground = lib.os.colors.pearl;
    format-background = lib.os.colors.black;
    format-padding = 2;
  };
}))
