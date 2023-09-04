{ config, lib, pkgs, ... }:

(lib.os.applyHmUsers (_: {
  services.redshift = {
    inherit (config.location) latitude longitude;
    enable = true;
    provider = "manual";
    tray = true;
    temperature = {
      day = 7000;
      night = 2500;
    };
    # settings = {
    #   brightness-day = 1;
    #   brightness-night = 0.4;
    # };
  };
})) // {
  services.gnome.at-spi2-core.enable = true;
}
