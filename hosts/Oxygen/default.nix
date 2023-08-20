{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-amd

    ./disko.nix

    os.nixosModules.audio
    os.nixosModules.bluetooth
    os.nixosModules.boot.systemd
    # os.nixosModules.display.dm.lightdm
    # os.nixosModules.display.monitors
    # os.nixosModules.display.wm.i3
    # os.nixosModules.documentation
    # os.nixosModules.gpu.nvidia
    # os.nixosModules.kernel
    # os.nixosModules.keyboard
    # os.nixosModules.location
    # os.nixosModules.nix
    os.nixosModules.sops
    # os.nixosModules.ssh
    # os.nixosModules.sudo
    os.nixosModules.user
    # os.nixosModules.virtualisation.docker
    # os.nixosModules.virtualisation.qemu
    # os.nixosModules.yubikey
  ];

  # So that gnome3 pinentry in home-manager gpg-agent works for non-gnome based systems
  services.dbus.packages = [ pkgs.gcr ];

  networking.hostId = "83b0a257";

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:9:0:0";
    amdgpuBusId = "PCI:0:2:0";
  };

  security.polkit.enable = true;
}
