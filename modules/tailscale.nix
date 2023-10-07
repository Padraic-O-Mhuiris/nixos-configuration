{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.tailscale ];

  # enable the tailscale service
  services.tailscale.enable = true;

}
