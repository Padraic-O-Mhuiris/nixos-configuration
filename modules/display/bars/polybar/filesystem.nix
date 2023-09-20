{ lib, ... }:

(lib.os.hm (user: {
  services.polybar.settings."module/filesystem" = {
    type = "internal/fs";
    mount-0 = "/";
    mount-1 = "/home";
    mount-2 = "/nix";
    interval = 10;
    fixed-values = true;
    spacing = 2;

    format-mounted = "<label-mounted>";
    label-mounted = "%{T2}%{T-} %mountpoint% %used%";
  };
}))
