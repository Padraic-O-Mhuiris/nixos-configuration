{ config, lib, pkgs, ... }:

{
  stylix.fonts = {
    serif = {
      package = pkgs.ubuntu_font_family;
      name = "Ubuntu";
    };
    sansSerif = config.stylix.fonts.serif;
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
      name = "Iosevka NFP SemiBold";
    };
    emoji = config.stylix.fonts.monospace;
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts
      # iosevka
      # ubuntu_font_family
      dejavu_fonts
      liberation_ttf
      roboto
      fira-code
      jetbrains-mono
      siji
      font-awesome
      cascadia-code
      nerdfonts
      #(nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };
}
