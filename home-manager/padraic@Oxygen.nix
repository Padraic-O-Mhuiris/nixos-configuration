{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [
    ./users/padraic
    ./firefox

    # ./hyprland
    # ./sway
    #./i3

    ./emacs
    # ./helix.nix
    ./dunst.nix
    ./cli.nix
  ];
}
