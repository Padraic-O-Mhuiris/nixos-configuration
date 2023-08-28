{ config, lib, pkgs, ... }:

lib.os.applyHmUsers (_: {
  home.packages = with pkgs; [ dconf ];

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 16;
    };
    font = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
      size = 10;
    };
  };
}) // {
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      # iosevka
      ubuntu_font_family
      dejavu_fonts
      liberation_ttf
      roboto
      fira-code
      jetbrains-mono
      siji
      font-awesome
      cascadia-code
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka NFP SemiBold" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Roboto" ];
      };
    };
  };

  console.font = "Terminus 32";
}
