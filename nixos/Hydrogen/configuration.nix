{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    outputs.nixosModules.defaultUser

    # outputs.homeConfigurations."padraic@Hydrogen"

    inputs.home-manager.nixosModules.home-manager
    inputs.sops.nixosModules.sops
    inputs.hardware.nixosModules.dell-xps-15-9520
    # inputs.hyprland.nixosModules.default

    ./hardware-configuration.nix
    ./boot.nix

    ../common
  ];

  home-manager = {
    users.${config.defaultUser.name} = import (../../home-manager
      + "/${config.defaultUser.name}@${config.networking.hostName}.nix");
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # environment.systemPackages = with pkgs; [
  #   # nvidia
  #   glxinfo
  #   nvtop-nvidia
  #   nvidia-offload
  # ];

  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  defaultUser = {
    name = "padraic";
    sshKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
  };

  programs.zsh.enable = true;
  programs.hyprland.enable = true;

  virtualisation.libvirtd.enable = true;

  networking = {
    hostName = "Hydrogen";
    hostId = "3f90d23a";
  };
  security.polkit.enable = true;

  # services.xserver = {
  #   enable = true;
  #   # displayManager = {
  #   #   defaultSession = "none";
  #   #   autoLogin = {
  #   #     enable = true;
  #   #     user = config.defaultUser.name;
  #   #   };
  #   # };
  #   # windowManager.i3 = {
  #   #   enable = true;
  #   #   extraPackages = with pkgs; [
  #   #     dmenu # application launcher most people use
  #   #     i3status # gives you the default i3 status bar
  #   #     i3lock # default i3 screen locker
  #   #     i3blocks # if you are planning on using i3blocks over i3status
  #   #   ];
  #   # };
  #   layout = "gb";
  #   libinput.enable = true;
  #   videoDrivers = [ "nvidia" ];
  #   xkbOptions = "ctrl:swapcaps";
  # };

  system.stateVersion = "23.05";
}
