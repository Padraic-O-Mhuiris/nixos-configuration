{ lib }:

let
  inherit (lib) pathIsDirectory pathExists;

  inherit (lib.attrsets)
    filterAttrs mapAttrsToList mapAttrs foldAttrs recursiveUpdate hasAttr
    mapAttrs' nameValuePair;

  inherit (lib.strings) hasSuffix removeSuffix;

  inherit (lib.lists) flatten elemAt any;

  inherit (builtins) readDir map;

in rec {
  /* Takes a list of attrsets and deeply merges into one large attrset

     Type: deepMergeAttrsList :: [Attrsets] -> Attrset

     Example: deepMergeAttrsList [ { a = { b = 1; }; } { a = { c = { d = 2; }; }}];
     => { a = { b = 1; c = { d = 2; }; }; }
  */
  deepMergeAttrsList =
    # A list of attrsets.
    attrsList:
    foldAttrs (item: acc: recursiveUpdate acc item) { } attrsList;

  moduleAttrsByPath = path:
    if (pathExists path) && (pathIsDirectory path) then
      (let
        filesInPath = readDir path;

        regularFilesInPath = mapAttrs' (name: _:
          nameValuePair (removeSuffix ".nix" name) (import (path + "/${name}")))
          (filterAttrs (k: v: v == "regular" && (hasSuffix ".nix" k))
            filesInPath);

        hasDefaultDotNix = lib.hasAttr "default.nix" filesInPath;

        files = if hasDefaultDotNix then (import path) else regularFilesInPath;

        dirs = mapAttrs' (name: _:
          nameValuePair name (if hasDefaultDotNix then
            { }
          else
            (moduleAttrsByPath (path + "/${name}"))))
          (filterAttrs (k: v: v == "directory") filesInPath);
      in if hasDefaultDotNix then files else (files // dirs))
    else
      { };

  zeroth = list: elemAt list 0;

  first = list: elemAt list 1;
}
