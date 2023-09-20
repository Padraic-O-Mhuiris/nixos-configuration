{ lib, ... }:

(lib.os.hm (user:
  { config, ... }: {
    services.polybar.settings."module/battery" = {
      type = "internal/battery";
      full-at = 99;
      low-at = 10;
      battery = "BAT0";
      adapter = "AC";
      poll-interval = 5;
      time-format = "%H:%M";

      format-charging =
        "%{F${lib.os.colors.yellow}}%{T2}<animation-charging>%{T-} ◦ <label-charging>%{F-}";
      label-charging = "%time% ◦ %percentage_raw%% ";

      format-discharging =
        "%{F${lib.os.colors.yellow}}%{T2}<ramp-capacity>%{T-} ◦ <label-discharging>%{F-}";
      label-discharging = "%time% ◦ %percentage_raw%%";

      format-full =
        "%{F${lib.os.colors.green}}%{T2}<ramp-capacity>%{T-} ◦ <label-full>%{F-}";
      label-full = "%percentage_raw%%";

      format-low =
        "%{F${lib.os.colors.red}}%{T2}<animation-low>%{T-} ◦ <label-low>%{F-}";
      label-low = "%time% ◦ %percentage_raw%%";

      ramp-capacity-0 = "";
      ramp-capacity-1 = "";
      ramp-capacity-2 = "";
      ramp-capacity-3 = "";
      ramp-capacity-4 = "";

      bar-capacity-width = 10;

      animation-charging-0 = "";
      animation-charging-1 = "";
      animation-charging-2 = "";
      animation-charging-3 = "";
      animation-charging-4 = "";
      animation-charging-framerate = 1000;

      animation-discharging-0 = "";
      animation-discharging-1 = "";
      animation-discharging-2 = "";
      animation-discharging-3 = "";
      animation-discharging-4 = "";
      animation-discharging-framerate = 1000;

      animation-low-0 = "";
      animation-low-1 = "";
      animation-low-framerate = 500;
    };
  }))
