{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./users/padraic
    ./firefox
    ./hyprland.nix
    ./emacs.nix
    ./cli.nix
  ];
}
