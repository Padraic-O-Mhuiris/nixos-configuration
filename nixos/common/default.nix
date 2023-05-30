{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./bluetooth.nix
    ./display.nix
    ./fonts.nix
    ./networking.nix
    ./nix.nix
    ./redshift.nix
    ./ssh.nix
    ./sops.nix
    ./user.nix
  ];
}
