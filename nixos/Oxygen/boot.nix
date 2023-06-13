{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices = {
      "crypted_home".device =
        "/dev/disk/by-uuid/a2f08e24-0e7e-4a7d-88f9-2f9fbbada9df";
      "crypted_system".device =
        "/dev/disk/by-uuid/e3d5a8e2-63e2-449e-89ea-4c4390198134";
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = pkgs.nixos-grub2-theme;
      };
    };
  };
}
