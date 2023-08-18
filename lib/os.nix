{ os, osCfg, lib, utils }:

let
  inherit (utils) deepMergeAttrsList;

  inherit (lib.attrsets) mapAttrsToList;

  inherit (osCfg) users;
in {
  applyUsers = fn:
    deepMergeAttrsList
    (mapAttrsToList (user: userConfig: fn { inherit user userConfig; })
      osCfg.users);
}
