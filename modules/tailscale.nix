{ config, lib, pkgs, ... }:

# The authKeyFile is typically a one-time authentication key created on the
# website. Once authenticated, the tailscaled service will populate
# /var/lib/tailscale with state to connect to the tailnet
#
# For adding newer devices, create an authentication key and the host should
# autoconnect to the network
{
  environment.systemPackages = [ pkgs.tailscale ];

  sops.secrets.tailscale_auth = { };

  # enable the tailscale service
  services.tailscale.enable = true;
  services.tailscale.permitCertUid = "patrick.morris.310@gmail.com";
  services.tailscale.authKeyFile = config.sops.secrets.tailscale_auth.path;

  networking.nameservers = [ "100.100.100.100" ];
  networking.search = [ "tail684cf.ts.net" ];

  environment.persistence."/persist".directories = [ "/var/lib/tailscale" ];
}
