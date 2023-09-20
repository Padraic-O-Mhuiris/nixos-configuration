{ os, lib, utils }:

let
  inherit (utils) deepMergeAttrsList generateBase16Mnemonic;

  inherit (lib.attrsets) mapAttrsToList;

  inherit (os) users;
in rec {
  inherit utils;

  user = fn:
    (deepMergeAttrsList
      (mapAttrsToList (_: userConfig: fn userConfig) os.users));

  hm = fn:
    (user (userConfig: {
      home-manager.users.${userConfig.name} = (fn userConfig);
    }));

  mapUsers = fn: (mapAttrsToList (_: userConfig: fn userConfig) os.users);

  # TODO Remove for nixosModule
  colors = utils.generateBase16Mnemonic { inherit (os) theme; };
}
