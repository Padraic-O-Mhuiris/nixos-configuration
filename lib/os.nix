{ os, osCfg, lib, utils }:

let
  inherit (utils) deepMergeAttrsList;

  inherit (lib.attrsets) mapAttrsToList;

  inherit (osCfg) users;
in
rec {

  applyUsers = fn:
    (deepMergeAttrsList
      (mapAttrsToList (_: userConfig: fn userConfig) osCfg.users));

  applyHmUsers = fn:
    applyUsers (user: { home-manager.users.${user.name} = (fn user); });

  mapUsers = fn: (mapAttrsToList (_: userConfig: fn userConfig) osCfg.users);

}
