{ lib }:

let
  inherit (lib) pathIsDirectory pathIsRegularFile pathExists throwIf;

  inherit (lib.attrsets)
    filterAttrs mapAttrsToList mapAttrs recursiveUpdate hasAttr mapAttrs'
    nameValuePair;

  inherit (lib.asserts) assertMsg;

  inherit (lib.strings) hasSuffix hasPrefix removeSuffix;

  inherit (lib.lists) flatten elemAt any fold forEach last;

  inherit (builtins) readDir;

in
rec {
  /* Takes a list of attrsets and deeply merges into one large attrset

     Type: deepMergeAttrsList :: [Attrsets] -> Attrset

     Example: deepMergeAttrsList [ { a = { b = 1; }; } { a = { c = { d = 2; }; }}];
     => { a = { b = 1; c = { d = 2; }; }; }
  */
  deepMergeAttrsList =
    # A list of attrsets.
    attrsList:
    (fold (item: acc: recursiveUpdate acc item) { } attrsList);

  moduleAttrsByPath = path:
    if (pathExists path) && (pathIsDirectory path) then
      (
        let
          filesInPath = readDir path;

          regularFilesInPath = mapAttrs'
            (name: _:
              nameValuePair (removeSuffix ".nix" name) (import (path + "/${name}")))
            (filterAttrs
              (k: v: v == "regular" && (hasSuffix ".nix" k) && !(hasPrefix "_" k))
              filesInPath);

          hasDefaultDotNix = hasAttr "default.nix" filesInPath;

          files = if hasDefaultDotNix then (import path) else regularFilesInPath;

          dirs = mapAttrs'
            (name: _:
              nameValuePair name (if hasDefaultDotNix then
                { }
              else
                (moduleAttrsByPath (path + "/${name}"))))
            (filterAttrs (k: v: v == "directory") filesInPath);
        in
        if hasDefaultDotNix then files else (files // dirs)
      )
    else
      { };

  pathIsNixFile = path:
    (pathIsRegularFile path) && (hasSuffix ".nix" (toString path));

  pathIsYamlFile = path:
    (pathIsRegularFile path) && (hasSuffix ".yaml" (toString path));

  pathIsJsonFile = path:
    (pathIsRegularFile path) && (hasSuffix ".json" (toString path));

  genHostPaths = path: host: rec {
    inherit host;
    hostDir = (path + "/${host}");
    hostFilePath = (hostDir + "/default.nix");
    diskoFilePath = (hostDir + "/disko.nix");
    secretsFilePath = (hostDir + "/secrets.yaml");
  };

  sanitizeOsConfig = osCfgWithModulesAndSettings:
    filterAttrs (k: v: k != "settings" && k != "modules")
      osCfgWithModulesAndSettings;

  zeroth = list: elemAt list 0;

  first = list: elemAt list 1;
}
