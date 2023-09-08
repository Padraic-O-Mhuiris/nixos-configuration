{ lib, ... }:

(lib.os.hm (user:
  { config, ... }:
  let colors = config.lib.stylix.colors.withHashtag;
  in {
    services.polybar.settings."module/wifi" = {
      type = "internal/network";
      interface = "wlp0s20f3"; # TODO Configure with networking
      interface-type = "wireless";
      interval = 1.0;
      accumulate-stats = true;

      format-connected = "<label-connected>";
      label-connected = "%local_ip% ◦ %essid%";
      label-connected-foreground = colors.green;
    };
  }))
