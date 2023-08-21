{ config, lib, pkgs, ... }:

lib.os.applyHmUser (_: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
})
