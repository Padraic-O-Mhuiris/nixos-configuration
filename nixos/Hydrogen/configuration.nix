# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {

  imports = [
    outputs.homeConfigurations."padraic@Hydrogen"

    inputs.sops.nixosModules.sops
    inputs.hardware.nixosModules.dell-xps-15-9520

    ./hardware-configuration.nix
    ./boot.nix

    ../common
    ../users/padraic.nix
  ];

  environment.systemPackages = with pkgs; [
    # nvidia
    glxinfo
    nvtop-nvidia
    nvidia-offload
  ];

  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  networking = {
    hostName = "Hydrogen";
    hostId = "3f90d23a";
  };

  services.xserver = {
    enable = true;
    autoLogin = {
      enable = true;
      user = "padraic";
    };
    layout = "gb";
    libinput.enable = true;
    videoDrivers = [ "nvidia" ];
    xkbOptions = "ctrl:swapcaps";
  };

  system.stateVersion = "23.05";
}
