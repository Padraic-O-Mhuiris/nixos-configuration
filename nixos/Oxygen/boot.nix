{ config, lib, pkgs, ... }:

{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    initrd.luks.devices = {
      "crypted_home".device =
        "/dev/disk/by-uuid/a2cdfaa5-2566-46c9-828e-0aedda7964a3";
      "crypted_system".device =
        "/dev/disk/by-uuid/328f08e9-20ab-4001-9f1a-4d6fb82fe4de";
    };
    loader = {
      efi = { canTouchEfiVariables = true; };
      systemd-boot.enable = true;
    };
    plymouth = { enable = true; };
  };
}
