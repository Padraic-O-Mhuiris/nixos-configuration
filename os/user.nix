{ users, config, lib, ... }:
let

  deepMergeAttrsList = attrsList:
    lib.attrsets.foldAttrs (item: acc: lib.attrsets.recursiveUpdate acc item)
    { } attrsList;

  # users = users;
  userArgsList =
    lib.mapAttrsToList (user: userConfig: { inherit user userConfig; }) users;

  userFns = config.__os__.user;

  userAttrs = deepMergeAttrsList (lib.flatten
    (lib.lists.map (userArg: lib.lists.map (fn: fn userArg) userFns)
      userArgsList));
in {
  options.__os__ = {
    user = lib.mkOption {
      type = lib.types.listOf
        (lib.types.functionTo (lib.types.attrsOf lib.types.unspecified));
      description = "";
      default = [ ];
    };

    __users__ = lib.mkOption {
      internal = true;
      type = lib.types.unspecified;
      apply = (x: userAttrs);
      default = null;
    };

  };

  #config = config.__os__.__users;
  # config.__os__.__users__ = userAttrs;

  # deepMergeAttrsList (lib.flatten (lib.forEach
  # (lib.attrsets.mapAttrsToList
  #   (user: userConfig: { inherit user userConfig; })
  #   os.${config.networking.hostname}.users) (userAttr:
  #     (lib.forEach config.__os__.user (fn: (fn userAttr))))));

}
