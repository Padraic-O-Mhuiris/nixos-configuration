{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices = {
      "crypted_home".device = ''
        /dev/disk/by-uuid/64a43f03-229b-49f7-bc20-66037c4a124a
      '';
      "crypted_system".device =
        "/dev/disk/by-uuid/69c366c2-89fb-4db5-b17f-87aee0fcd71b";
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
