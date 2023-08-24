{ lib }:

let inherit (lib.attrsets) mapAttrs;
in rec {
  utils = import ./utils.nix { inherit lib; };

  mkOsLib = { os, osCfg }: import ./os.nix { inherit os osCfg lib utils; };

  mkLibForFlake = osFlakeConfig:
    lib.extend (_: prev:
      prev // {
        inherit utils;
        os = mapAttrs (os: osCfg: mkOsLib { inherit os osCfg; }) osFlakeConfig;
      }) // utils;

  mkLibForNixosConfiguration = { os, osCfg }@args:
    lib.extend (_: prev:
      prev // {
        inherit utils;
        os = mkOsLib args;
      });
}
