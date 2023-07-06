{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./users/padraic
    ./firefox
    ./hyprland
    ./emacs.nix
    ./cli.nix
  ];
}
