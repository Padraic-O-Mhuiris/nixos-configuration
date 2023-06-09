{ inputs, outputs, lib, config, pkgs, ... }:

{
  defaultUser = {
    name = "padraic";
    email = "patrick.morris.310@gmail.com";
    githubUser = "Padraic-O-Mhuiris";
    sshKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
    gpgKey = "9A51DBF629888EE75982008D9DCE7055406806F8";
  };

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

  # So that gnome3 pinentry in home-manager gpg-agent works for non-gnome based systems
  services.dbus.packages = [ pkgs.gcr ];

  # Required so zsh completion works for systemd
  environment.pathsToLink = [ "/share/zsh" ];

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
