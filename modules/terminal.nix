{ lib, pkgs, ... }:

lib.os.hm (_:
  { config, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 6; # TODO globalise
        window.padding = {
          x = 10;
          y = 10;
        };
        scale_with_dpi = true;
      };
    };

    home.sessionVariables.TERMINAL =
      "${lib.getExe' config.programs.alacritty.package "alacritty"}";
  })
