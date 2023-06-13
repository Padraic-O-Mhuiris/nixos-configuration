{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices = {
      "crypted_home".device =
        "/dev/disk/by-uuid/9e337ee3-3c90-4003-836a-236888701cc9";
      "crypted_system".device =
        "/dev/disk/by-uuid/df171b85-b5f1-4132-a26f-4e16eebaac1e";
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      efi = {
        efiSysMountPoint = "/efi";
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   device = "nodev";
      #   theme = pkgs.nixos-grub2-theme;
      # };
    };
  };
}
