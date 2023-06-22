{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager = {
      enable = true;
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
  # services.xserver = {
  #   enable = true;
  #   displayManager = {
  #     sddm = {
  #       enable = true;
  #       enableHidpi = true;
  #       # autoLogin.relogin = false;
  #     };
  #     # autoLogin = {
  #     #   enable = true;
  #     #   user = config.defaultUser.name;
  #     # };
  #   };
  # };
}
