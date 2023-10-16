{ config, lib, pkgs, ... }:

{
  stylix.fonts = {
    serif = {
      package = pkgs.iosevka-comfy.comfy-motion-duo;
      name = "Iosevka Comfy Motion Duo";
    };
    sansSerif = {
      package = pkgs.iosevka-comfy.comfy-duo;
      name = "Iosevka Comfy Duo";
    };
    monospace = {
      package = pkgs.iosevka-comfy.comfy-fixed;
      name = "Iosevka Comfy Fixed";
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
