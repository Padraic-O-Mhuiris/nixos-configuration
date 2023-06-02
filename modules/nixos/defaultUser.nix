{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.defaultUser;
in {
  options.defaultUser = {
    name = mkOption {
      type = types.str;
      default = "";
    };
    sshKey = mkOption {
      type = types.str;
      default = "";
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
      # passwordFile = config.sops.secrets."user@${cfg.name}".path;
      initialPassword = "abc123";
      uid = 1000;
      extraGroups = [ "wheel" ] ++ cfg.groups;
      shell = pkgs.bashInteractive;
    };
  };
}
