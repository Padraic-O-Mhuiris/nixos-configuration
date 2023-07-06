{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./users/padraic
    ./firefox
    ./eww
    ./hyprland.nix
    ./emacs.nix
    ./cli.nix
  ];
}
