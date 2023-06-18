# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    "crypted_home".device =
      "/dev/disk/by-uuid/a2cdfaa5-2566-46c9-828e-0aedda7964a3";
    "crypted_system".device =
      "/dev/disk/by-uuid/328f08e9-20ab-4001-9f1a-4d6fb82fe4de";
  };

  networking.networkmanager.enable = true;
  services.xserver.enable = true;

  users.users.padraic = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "abc123";
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      trusted-users = [ "@wheel" ];
      allowed-users = [ "@wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [ vim wget git ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "23.05";
}
