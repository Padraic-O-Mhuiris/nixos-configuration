{ inputs, config, lib, pkgs, ... }:

{
  services.xserver = { enable = true; };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
