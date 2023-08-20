{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      # configFile = "";
    };
    displayManager.defaultSession = "none+i3";
  };

  environment.systemPackages = with pkgs; [ xorg.xdpyinfo ];
}
