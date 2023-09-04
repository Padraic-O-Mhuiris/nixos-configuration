{ lib, pkgs }:

let
  base16ThemesDir = "${pkgs.base16-schemes.outPath}/share/themes";

  inherit (lib.types) enum;

  inherit (lib.strings) removeSuffix;

  inherit (lib.lists) mapAttrsToList;

  inherit (builtins) readDir;
in {
  themes = enum
    (mapAttrsToList (k: _v: removeSuffix ".yaml" k) (readDir base16ThemesDir));
}
