{ config, lib, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      iosevka
      ubuntu_font_family
      dejavu_fonts
      liberation_ttf
      roboto
      fira-code
      jetbrains-mono
      siji
      font-awesome
      cascadia-code
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Roboto" ];
      };
    };
  };

}
