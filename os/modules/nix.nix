{ inputs, config, lib, pkgs, ... }:

{
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
