{ config, lib, pkgs, inputs, outputs, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.defaultUser;
in {
  options.defaultUser = {
    name = mkOption {
      type = types.str;
      default = "";
    };
    email = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    sshKey = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    gpgKey = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    githubUser = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    groups = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = {
    sops.secrets."user@${cfg.name}" = { neededForUsers = true; };

    users.users.${cfg.name} = {
      home = "/home/${cfg.name}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ cfg.sshKey ];
      passwordFile = config.sops.secrets."user@${cfg.name}".path;
      uid = 1000;
      extraGroups = [ "wheel" ] ++ cfg.groups;
      shell = pkgs.bashInteractive;
    };

    home-manager = {
      users.${cfg.name} = import (../../home-manager + "/${cfg.name}.nix");
      extraSpecialArgs = {
        inherit inputs outputs;
        defaultUser = cfg;
      };
    };
  };
}
