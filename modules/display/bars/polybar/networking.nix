{ lib, ... }:

(lib.os.hm (user:
  let
    networkCfg = {
      type = "internal/network";
      interval = 1.0;
      accumulate-stats = true;

      format-connected = "<label-connected>";
      label-connected = "%local_ip% ◦ %essid%";
      label-connected-foreground = lib.os.colors.green;
    };

  in {
    services.polybar.settings = {
      "module/wifi" = networkCfg // ({
        interface = "wlp0s20f3"; # TODO Configure with networking
        interface-type = "wired";
      });

      services.polybar.settings."module/networking" = networkCfg // ({
        type = "internal/network";
        interface = "wlp0s20f3"; # TODO Configure with networking
        interface-type = "wired";
      });
    };
  }))
