{ lib, ... }:

(lib.os.hm (_: {
  services.polybar.settings."module/date" = {
    type = "internal/date";
    interval = 1;
    label = "%{T2}%{T-} %date%";
    format-foreground = lib.os.colors.black;
    format-background = lib.os.colors.pearl;
    format-padding = 1;
    date = "%H:%M";
    date-alt = "%A, %d %B %Y";
  };
}))
