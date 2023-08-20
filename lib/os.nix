{ os, osCfg, lib, utils }:

let
  inherit (utils) deepMergeAttrsList;

  inherit (lib.attrsets) mapAttrsToList;

  inherit (osCfg) users;
in rec {
  applyUsers = fn: deepMergeAttrsList (mapUsers fn);

  mapUsers = fn: (mapAttrsToList (_: userConfig: fn userConfig) osCfg.users);
}
