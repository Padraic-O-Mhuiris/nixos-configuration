{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ age sops ssh-to-age ];

  sops = {
    defaultSopsFile = ./.. + "/${config.networking.hostName}/secrets.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
