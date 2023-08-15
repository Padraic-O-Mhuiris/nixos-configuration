{ inputs, config, lib, pkgs, ... }:

{
  imports = [ inputs.srvos.common.networking ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ ];
      checkReversePath = "loose";
    };
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    hosts = { "127.0.0.1" = [ config.networking.hostName ]; };
  };

  programs.nm-applet.enable = true;

  defaultUser.groups = [ "networkManager" ];

  environment.systemPackages = with pkgs; [ gnome-icon-theme ];
}
