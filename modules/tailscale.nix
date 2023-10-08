{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.tailscale ];

  sops.secrets.tailscale_auth = { };

  # enable the tailscale service
  services.tailscale.enable = true;
  services.tailscale.permitCertUid = "patrick.morris.310@gmail.com";
  services.tailscale.authKeyFile = config.sops.secrets.tailscale_auth.path;

  networking.nameservers = [ "100.100.100.100" ];
  networking.search = [ "tail684cf.ts.net" ];
}
