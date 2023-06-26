{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
  ];

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableBrowserSocket = true;
    pinentryFlavor = "gnome3";
  };

}
