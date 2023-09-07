{ config, lib, pkgs, ... }:

lib.os.hm (_: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
})
