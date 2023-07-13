{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./users/padraic
    ./firefox
    ./hyprland
    ./dunst.nix
    ./rofi.nix
    ./emacs.nix
    ./cli.nix
  ];
}
