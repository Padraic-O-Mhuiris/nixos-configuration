{ config, lib, pkgs, ... }:

lib.os.hm (_: {
  home.shellAliases = {
    "nr" =
      "sudo nixos-rebuild --flake $HOME/code/nix/nixos-configuration#${config.networking.hostName} switch --show-trace --verbose";
  };
})
