{ inputs }:

let
  inherit (inputs.nixpkgs) lib;

  inherit (lib.attrsets) mapAttrs;

  # TODO Is there a better way of implementing this?
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

in rec {
  utils = import ./utils.nix { inherit lib; };

  types = import ./types.nix { inherit lib pkgs; };

  mkOsLib = { os, osCfg }: import ./os.nix { inherit os osCfg lib utils; };

  mkLibForFlake = osFlakeConfig:
    lib.extend (_: prev:
      prev // {
        inherit utils;
        os = mapAttrs (os: osCfg: mkOsLib { inherit os osCfg; }) osFlakeConfig;
      }) // utils // types;

  mkLibForNixosConfiguration = { os, osCfg }@args:
    lib.extend (_: prev:
      prev // {
        inherit utils;
        os = mkOsLib args;
      });

}
