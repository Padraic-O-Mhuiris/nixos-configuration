{ config, lib, pkgs, ... }:

lib.os.applyHmUsers (_: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
})
