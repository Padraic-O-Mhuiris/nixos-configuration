{ flake, lib, config, pkgs, ... }:

{
  imports = [
    # flake.inputs.hardware.nixosModules.common-hidpi
    # flake.inputs.hardware.nixosModules.common-pc
    # flake.inputs.hardware.nixosModules.common-pc-ssd
    # flake.inputs.hardware.nixosModules.common-cpu-amd
    # flake.inputs.hardware.nixosModules.common-gpu-nvidia-prime

    # flake.nixosModules.audio
    # flake.nixosModules.bluetooth
    # flake.nixosModules.ssh

    ./disko.nix
  ];

  # So that gnome3 pinentry in home-manager gpg-agent works for non-gnome based systems
  services.dbus.packages = [ pkgs.gcr ];

  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  #virtualisation.libvirtd.enable = true;

  hardware = {
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        nvidiaBusId = "PCI:9:0:0";
        amdgpuBusId = "PCI:0:2:0";
      };
      forceFullCompositionPipeline = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  security.polkit.enable = true;
}
