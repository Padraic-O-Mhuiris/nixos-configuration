{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.sddm = { enable = true; };
  };
}
