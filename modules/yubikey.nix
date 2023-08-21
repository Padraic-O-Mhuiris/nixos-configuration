{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
  ];

  # Allows for smartcard detection
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

  hardware.gpgSmartcards.enable = true;
}
