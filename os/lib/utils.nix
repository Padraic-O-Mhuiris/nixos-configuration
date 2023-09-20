{ inputs, lib }:

let
  inherit (lib)
    pathIsDirectory pathIsRegularFile pathExists throwIf throwIfNot unique;

  inherit (lib.attrsets)
    filterAttrs mapAttrsToList mapAttrs recursiveUpdate hasAttr mapAttrs'
    nameValuePair;

  inherit (lib.asserts) assertMsg;

  inherit (lib.strings) hasSuffix hasPrefix removeSuffix;

  inherit (lib.lists) flatten elemAt any fold forEach last length zipListsWith;

  inherit (builtins) readDir;

  # TODO Is there a better way of implementing this?
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in rec {
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
      (let
        filesInPath = readDir path;

        regularFilesInPath = mapAttrs' (name: _:
          nameValuePair (removeSuffix ".nix" name) (import (path + "/${name}")))
          (filterAttrs
            (k: v: v == "regular" && (hasSuffix ".nix" k) && !(hasPrefix "_" k))
            filesInPath);

        hasDefaultDotNix = hasAttr "default.nix" filesInPath;

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

  base16ThemesDir = "${pkgs.base16-schemes.outPath}/share/themes";

  base16ThemeNames =
    (mapAttrsToList (k: _v: removeSuffix ".yaml" k) (readDir base16ThemesDir));

  defaultBase16MnemonicLabels = [
    "black"
    "charcoal"
    "graphite"
    "slate"
    "gray"
    "silver"
    "pearl"
    "white"
    "red"
    "orange"
    "yellow"
    "green"
    "aqua"
    "blue"
    "purple"
    "violet"
  ];

  base16ThemeAttrs = theme: {
    inherit (((pkgs.callPackage inputs.base16.lib { }).mkSchemeAttrs
      "${pkgs.base16-schemes.outPath}/share/themes/${theme}.yaml").withHashtag)
      base00 base01 base02 base03 base04 base05 base06 base07 base08 base09
      base0A base0B base0C base0D base0E base0F;
  };

  base16ThemeList = theme:
    let
      inherit (base16ThemeAttrs theme)
        base00 base01 base02 base03 base04 base05 base06 base07 base08 base09
        base0A base0B base0C base0D base0E base0F;
    in [
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      base0F
    ];

  validateBase16MnemonicLabels = labels:
    let
      lengthCondition = (length labels) == 16;
      uniqueCondition = (length (unique labels)) == 16;
    in (throwIfNot (lengthCondition && uniqueCondition)
      "Labels list must be of length 16 and all unique" labels);

  /* https://github.com/chriskempson/base16/blob/main/styling.md

     Using base16-scheme, creates mnemonic referencing of schema, in general the
     first 8 are dark to light and the remaining 8 are red to violet on the
     color spectrum.
     To note, the color labels indicate the framework, not what the actual color
     for which the theme describes. Some themes vary where what is in colors.red
     could be a visual blue.
  */
  generateBase16Mnemonic = { theme, labels ? defaultBase16MnemonicLabels }:
    deepMergeAttrsList
    (zipListsWith (a: b: { "${a}" = b; }) (validateBase16MnemonicLabels labels)
      (base16ThemeList theme));
}
