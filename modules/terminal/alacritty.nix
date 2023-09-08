{ lib, pkgs, ... }:

(lib.os.hm (_:
  { config, ... }: {

    programs.alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 10;
          y = 10;
        };
        scale_with_dpi = false;
      };
    };

    stylix.targets.alacritty.enable = true;

    home.sessionVariables = {
      TERMINAL = "${lib.getExe' config.programs.alacritty.package "alacritty"}";
      WINIT_X11_SCALE_FACTOR = 1;
    };
  }))
