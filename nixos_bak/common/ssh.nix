{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ inputs.srvos.common.well-known-hosts inputs.srvos.common.openssh ];

  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    openFirewall = !config.services.tailscale.enable;
    settings = {
      PermitRootLogin = "prohibit-password";
      UseDns = lib.mkForce true;
      PasswordAuthentication = false;
    };
    hostKeys = [{
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
      rounds = 100;
      comment = "${config.networking.hostName}";
    }];
  };
}
