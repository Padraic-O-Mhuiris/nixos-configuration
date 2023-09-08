{ config, lib, pkgs, ... }:

lib.os.hm ({ name, ... }: {
  home = {
    packages = with pkgs; [ dconf ];
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
  };
})
