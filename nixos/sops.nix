{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.sops.nixosModules.sops ];

  environment.systemPackages = with pkgs; [ age sops ssh-to-age ];

  sops = {
    defaultSopsFile = ./hosts + "/${config.networking.hostName}/secrets.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
