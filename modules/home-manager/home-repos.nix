{ config, lib, pkgs, ... }:

let
  inherit (lib) hasPrefix hm literalExpression mkDefault mkIf mkOption removePrefix types;

  homeDirectory = config.home.homeDirectory;

  repoType = opt: basePathDesc: basePath: types.attrsOf (types.submodule (
    { name, config, ... }: {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether this repository should be cloned. This option allows specific
          repositories to be disabled.
        '';
      };
      url = mkOption {
        type = types.str;
        apply = p:
          let
            absPath = if hasPrefix "/" p then p else "${basePath}/${p}";
          in
          removePrefix (homeDirectory + "/") absPath;
        defaultText = literalExpression "url";
        description = ''
          Path to target repository relative to ${basePathDesc}.
        '';
      };
    }
  ));
in
{
  options.home.repos = {
    default = { };
    description = "Attribute set of git urls to clone into the users home directory";
    type = repoType "home.repos" "<envar>HOME</envar>" homeDirectory;
  };
}
