{ config, lib, pkgs, ... }:

lib.os.applyHmUsers (_: {
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 12;
      window.padding = {
        x = 10;
        y = 10;
      };
    };
  };
})
