{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.lightdm.enable = true;
}
