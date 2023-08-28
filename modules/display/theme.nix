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
})
