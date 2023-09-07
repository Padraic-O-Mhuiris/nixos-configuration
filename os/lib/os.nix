{ os, lib, utils }:

let
  inherit (utils) deepMergeAttrsList;

  inherit (lib.attrsets) mapAttrsToList;

  inherit (os) users;
in rec {
  user = fn:
    (deepMergeAttrsList
      (mapAttrsToList (_: userConfig: fn userConfig) os.users));

  hm = fn:
    (user (userConfig: {
      home-manager.users.${userConfig.name} = (fn userConfig);
    }));

  mapUsers = fn: (mapAttrsToList (_: userConfig: fn userConfig) os.users);

}
