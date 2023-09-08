{ lib, ... }:

(lib.os.hm (user:
  { config, ... }:
  let colors = config.lib.stylix.colors.withHashtag;
  in {
    services.polybar.settings."module/home" = {
      type = "custom/text";
      content = "%{T2}%{T-}";
      content-background = colors.white;
      content-foreground = colors.black;
      content-padding = 2;
    };
  }))
