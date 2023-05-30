{ config, lib, pkgs, ... }:

{
  services.geoclue2.enable = true;
  services.geoclue2.appConfig.redshift.isAllowed = true;

  services.redshift = {
    enable = true;
    brightness = {
      day = "1.0";
      night = "0.5";
    };
    temperature = {
      day = 5000;
      night = 3000;
    };
  };

}
