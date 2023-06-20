{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      autoLogin = {
        enable = true;
        relogin = false;
        user = config.defaultUser.name;
      };
    };
  };
}
