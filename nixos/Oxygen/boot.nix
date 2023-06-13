{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices = {
      "crypted_home".device =
        "/dev/disk/by-uuid/25e21acd-fef0-45ea-b7a6-ea8f1525d841";
      "crypted_system".device =
        "/dev/disk/by-uuid/0bdb9af3-e808-4466-a8a7-19e330a33808";
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi = {
        efiSysMountPoint = "/efi";
        canTouchEfiVariables = true;
      };
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   device = "nodev";
      #   theme = pkgs.nixos-grub2-theme;
      # };
    };
  };
}
