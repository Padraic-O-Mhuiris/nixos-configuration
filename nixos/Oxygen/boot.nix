{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices = {
      "crypted_home".device = ''
        /dev/disk/by-uuid/d5870829-f3e1-48b0-957f-602d7654b457
      '';
      "crypted_system".device =
        "/dev/disk/by-uuid/0f63cffa-45d0-409b-aa16-c04682a41842";
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      efi = {
        efiSysMountPoint = "/boot";
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
