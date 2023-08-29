{ config, lib, pkgs, ... }:

# TODO Extend to more structured config from os
lib.os.applyHmUsers (user: {

  programs.autorandr = {
    enable = true;
    profiles.main = {
      fingerprint = { "DP-0" = ""; };
      config = {
        "DP-0" = {
          enable = true;
          dpi = null;
          primary = true;
          position = "0x0";
          mode = "5120x1440";
          rate = "60.00";
        };
      };
    };
  };

  services.autorandr.enable = true;
})
