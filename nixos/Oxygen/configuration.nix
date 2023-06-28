{ inputs, outputs, lib, config, pkgs, ... }:

{
  defaultUser = {
    name = "padraic";
    email = "patrick.morris.310@gmail.com";
    githubUser = "Padraic-O-Mhuiris";
    sshKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
    gpgKey = "8544725A91D4B87821522A368DA36F90B33A4605";
  };

  imports = [
    outputs.nixosModules.defaultUser

    inputs.home-manager.nixosModules.home-manager
    inputs.sops.nixosModules.sops

    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia

    ./hardware-configuration.nix
    ./boot.nix
    ../common
  ];

  # So that gnome3 pinentry in home-manager gpg-agent works for non-gnome based systems
  services.dbus.packages = [ pkgs.gcr ];

  # Required so zsh completion in home-manager works for systemd
  environment.pathsToLink = [ "/share/zsh" ];

  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  programs.hyprland.enable = true;

  virtualisation.libvirtd.enable = true;

  networking = {
    hostName = "Oxygen";
    hostId = "3f90d23a";
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    prime = {
      nvidiaBusId = "PCI:9:0:0";
      amdgpuBusId = "PCI:0:2:0";
    };

  };

  hardware.opengl = {
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  security.polkit.enable = true;

  system.stateVersion = "23.05";
}
