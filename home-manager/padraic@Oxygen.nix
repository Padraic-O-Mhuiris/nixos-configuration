{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [
    ./users/padraic
    ./firefox
    # ./hyprland
    ./sway
    ./emacs
    ./helix.nix
    ./dunst.nix
    ./rofi.nix
    ./cli.nix
  ];
}
