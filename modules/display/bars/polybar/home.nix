{ lib, ... }:

(lib.os.hm (user: {
  services.polybar.settings."module/home" = {
    type = "custom/text";
    content = "%{T2}%{T-}";
    content-background = lib.os.colors.silver;
    content-foreground = lib.os.colors.black;
    content-padding = 2;
  };
}))
