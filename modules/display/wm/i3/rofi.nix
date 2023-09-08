{ config, lib, pkgs, ... }:

lib.os.hm (_: {
  programs.rofi = {
    enable = true;
    # font = "${config.stylix.fonts.monospace.name} ${
    #     toString (config.stylix.fonts.sizes.popups * 2)
    #   }";
  };

  stylix.targets.rofi.enable = true;
})
