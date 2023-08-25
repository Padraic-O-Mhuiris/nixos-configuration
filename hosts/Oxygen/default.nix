{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-amd

    ./disko.nix

    os.modules.audio
    os.modules.bluetooth
    os.modules.boot.systemd
    os.modules.browsers.firefox
    os.modules.common
    os.modules.display.dm.lightdm
    os.modules.display.monitors
    os.modules.display.theme
    os.modules.display.wm.i3
    os.modules.documentation
    os.modules.editors.emacs
    os.modules.filesystem
    os.modules.git
    os.modules.gpu.nvidia
    os.modules.gnupg
    os.modules.kernel
    os.modules.keyboard
    os.modules.location
    os.modules.nix
    os.modules.networking
    os.modules.sops
    os.modules.ssh
    os.modules.sudo
    os.modules.terminal
    os.modules.user
    os.modules.virtualisation.docker
    os.modules.virtualisation.qemu
    os.modules.yubikey
  ];

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:9:0:0";
    amdgpuBusId = "PCI:0:2:0";
  };

  networking.hostId = "83b0a257";
}
