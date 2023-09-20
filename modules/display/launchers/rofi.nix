{ lib, pkgs, ... }:

lib.os.hm (_:
  ({ config, ... }: {
    programs.rofi = {
      enable = true;
      # font = "${config.stylix.fonts.monospace.name} ${
      #     toString (config.stylix.fonts.sizes.popups * 2)
      #   }";
    };

    # TODO Better config, also think about integrations like bookmarks
    stylix.targets.rofi.enable = true;

    home.sessionVariables."APPS_LAUNCHER" =
      "${lib.getExe config.programs.rofi.finalPackage} -show drun";
  }))
