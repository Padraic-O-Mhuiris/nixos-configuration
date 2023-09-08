{ lib, ... }:

(lib.os.hm (user:
  { config, ... }:
  let colors = config.lib.stylix.colors.withHashtag;
  in {
    services.polybar.settings."module/date" = {
      type = "internal/date";
      interval = 1;
      label = "%{T2}%{T-} %date%";
      format-foreground = colors.background;
      format-background = colors.white;
      format-padding = 1;
      date = "%H:%M";
      date-alt = "%A, %d %B %Y";
    };
  }))
