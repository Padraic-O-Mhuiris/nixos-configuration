{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices = {
      "crypted_home".device =
        "/dev/disk/by-uuid/1572b005-ed31-4674-a90a-6c3f7d54f90b";
      "crypted_system".device =
        "/dev/disk/by-uuid/ddcaadc0-8096-4ec7-bf11-1aef73931c88";
    };

    # kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      efi = { canTouchEfiVariables = true; };
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
