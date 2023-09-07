{ lib, pkgs, validations }:

let

  inherit (lib) pathExists;

  inherit (lib.options) mkOption;

  inherit (lib.types) enum attrsOf submodule unspecified nullOr str listOf path;

  inherit (lib.strings) removeSuffix;

  inherit (lib.attrsets) mapAttrsToList;

  inherit (builtins) readDir;

  inherit (validations) mkHostsPathOptionApply mkModulesPathOptionApply;

  base16ThemesDir = "${pkgs.base16-schemes.outPath}/share/themes";
in
{
  themeOption = mkOption {
    type = enum (mapAttrsToList (k: _v: removeSuffix ".yaml" k)
      (readDir base16ThemesDir));
    description = "Enumerated selection of base16 themes";
    default = "nord";
  };

  usersOption = mkOption {
    type = attrsOf (submodule ({ name, ... }: {
      options = {
        name = mkOption {
          type = unspecified;
          description =
            "Name of the user, read-only, matches the key of the attrset";
          default = name;
          internal = true;
          readOnly = true;
        };
        email = mkOption {
          type = str; # TODO Add regex type
          description = "Email of the user";
        };
        github = mkOption {
          type = str; # TODO Add regex type
          description = "Github username of the user";
        };
        ssh = mkOption {
          type = str; # TODO Add regex type
          description = "Public ssh key of the user";
        };
        gpg = {
          fingerprint = mkOption {
            type = str;
            description = "User gpg fingerprint";
          };
          key = mkOption {
            type = str;
            description = "User gpg key";
          };
        };
      };
    }));
    default = { };
    description = "Attrs of user definitions";
  };

  mkNameOption = name:
    (mkOption {
      type = unspecified;
      description =
        "Name of the host, read-only, matches the key of the attrset";
      default = name;
      internal = true;
      visible = false;
      readOnly = true;
    });

  cpuOption = mkOption {
    type = enum [ "amd" "intel" ];
    description = "Kind of CPU";
    default = "intel";
  };

  gpuOption = mkOption {
    type = enum [ "amd" "intel" "nvidia" ];
    description = "Kind of gpu";
    default = "intel";
  };

  disksOption = mkOption {
    type = listOf str;
    description = "Disks of machine listed under /dev/disk/by-id/";
    default = [ ];
  };

  ipOptions = {
    local = lib.mkOption {
      type = str; # TODO Add regex type
      description = "Local IP address of machine";
    };
    remote = lib.mkOption {
      type = nullOr str;
      description = "Local IP address of machine";
      default = null;
    };
  };

  _nixosConfigurationOption = mkOption {
    internal = true;
    type = unspecified;
    default = null;
  };

  modulesPathOption = mkOption {
    type = path;
    description =
      "Path to modules directory which formulates the os.modules structure";
    default = ../../modules;
    # apply = (path: mkModulesPathOptionApply { inherit path; });
  };

  hostsPathOption = mkOption {
    type = path;
    description =
      "Path to hosts directory which must match the entries in the os data structure";
    default = ../../hosts;
    # apply = (path: mkHostsPathOptionApply { inherit configuration path; });
  };
}
