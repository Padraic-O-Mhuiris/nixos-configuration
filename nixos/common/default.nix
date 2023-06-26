{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./bluetooth.nix
    ./display.nix
    ./filemanager.nix
    ./fonts.nix
    ./networking.nix
    ./nix.nix
    ./ssh.nix
    ./sops.nix
    ./user.nix
    ./yubikey.nix
  ];
}
