{ config, lib, pkgs, ... }:

{

  boot = {
    initrd.luks.devices = {
      "crypted_home".device =
        "/dev/disk/by-uuid/a2cdfaa5-2566-46c9-828e-0aedda7964a3";
      "crypted_system".device =
        "/dev/disk/by-uuid/328f08e9-20ab-4001-9f1a-4d6fb82fe4de";
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
