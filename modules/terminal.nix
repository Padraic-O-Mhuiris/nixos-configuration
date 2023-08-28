{ lib, pkgs, ... }:

lib.os.applyHmUsers (_:
  { config, ... }: {
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

    home.sessionVariables.TERMINAL = "${config.programs.alacritty.package}";
  })
