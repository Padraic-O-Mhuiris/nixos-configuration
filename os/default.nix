{ lib, flake-parts-lib, self, config, inputs, ... }:

let
  cfg = config.flake.os;
  l = lib // builtins;

  deepMergeAttrsList = attrsList:
    lib.attrsets.foldAttrs (item: acc: lib.attrsets.recursiveUpdate acc item)
    { } attrsList;

  inherit (self.nixos-flake.lib) mkLinuxSystem;

  # userSubmodule definition
  userFlakeSubmodule = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the user";
          default = name;
        };

        email = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Email of the user";
          default = null;
        };

        github = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Github username of the user";
          default = null;
        };

        ssh = lib.mkOption {
          type = lib.types.nullOr lib.types.strMatching
            "^(ssh-ed25519s+AAAAC3NzaC1lZDI1NTE5|sk-ssh-ed25519@openssh.coms+AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29t|ssh-rsas+AAAAB3NzaC1yc2)[0-9A-Za-z+/]+[=]{0,3}(s.*)?$";
          description = "List of user ssh keys, first is primary";
          default = null;
        };

        gpg.fingerprint = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "User gpg fingerprint";
          default = null;
        };

        gpg.key = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "User gpg key";
          default = null;
        };
      };

    }));
    default = { };
    description = "Attrs of user definitions";
  };

in {

  options.flake.os = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the host";
          default = name;
        };

        # modules = lib.mkOption {
        #   type = lib.types.listOf lib.types.str;
        #   description =
        #     "List of home-manager modules defined in /home/default.nix";
        #   default = [ ];
        # };

        # homeModules = lib.mkOption {
        #   type = lib.types.listOf lib.types.str;
        #   description =
        #     "List of home-manager modules defined in /home/default.nix";
        #   default = [ ];
        # };

        # TODO If darwin is to be used
        # type = lib.mkOption {
        #   type = lib.types.enum [ "linux" "darwin" ];
        #   description = "Type of operating system";
        #   default = "linux";
        # };

        users = userFlakeSubmodule;

        system = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "system";
          default = null;
        };

        ip.local = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Local IP address of machine";
          default = null;
        };

        ip.remote = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Local IP address of machine";
          default = null;
        };

        _nixosUserModules = lib.mkOption {
          internal = true;
          type = lib.types.unspecified;
          default = null;
        };

        _nixosConfiguration = lib.mkOption {
          internal = true;
          type = lib.types.unspecified;
          default = null;
        };
      };
      config = let cfg = config;

      in {
        _nixosUserModules = (lib.mapAttrsToList (user: userConfig:
          ((lib.attrsets.foldAttrs
            (item: acc: lib.attrsets.recursiveUpdate acc item) { }
            (map (fn: fn { inherit user userConfig; })
              self.nixosConfigurations.${name}.config.__os__.user))))
          cfg.users);

        _nixosConfiguration."${name}" = self.inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (cfg) users; };
          modules = [
            # self.nixosModules."os@${name}"
            # inputs.sops.nixosModules.sops
            #self.nixosModules."padraic@Oxygen"

            ({ config, lib, ... }: {
              options.__os__.user = lib.mkOption {
                type = lib.types.listOf (lib.types.functionTo
                  (lib.types.attrsOf lib.types.unspecified));
                description = "";
                default = [ ];
              };
            })

            ({
              __os__.user = [
                ({ user, userConfig }: {
                  users.users.${user}.openssh.authorizedKeys.keys =
                    [ userConfig.ssh ];
                })
              ];
            })

            ({
              __os__.user = [
                ({ user, userConfig }: {
                  users.users.${user}.home = "/home/${user}";
                })
              ];
            })

            {
              # sops.defaultSopsFile = ./. + "/${name}/secrets.yaml";
              # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              networking.hostName = name;
              nixpkgs.hostPlatform = config.system;
              system.stateVersion = "23.05";
            }
          ];

        };
      };
    }));
    default = { };
    description = "Attrs of os definitions";
  };

  config = {

    flake = {
      inherit lib;

      # users = config.flake.os.Oxygen.users;
      # userClosures = config.flake.nixosConfigurations.Oxygen.config.__os__.user;

      # userAttrs = lib.flatten (lib.mapAttrsToList (user: userConfig:
      #   map (fn: fn { inherit user userConfig; }) userClosures) users);

      # mergedUserAttrs = lib.attrsets.foldAttrs
      #   (item: acc: lib.attrsets.recursiveUpdate acc item) { } userAttrs;

      #   applyUserFunctions = (fn:
      #     lib.mapAttrsToList (k: v:
      #       (fn ({
      #         user = k;
      #         userConfig = v;
      #       }))) self.os.Oxygen.users);

      #   deepMergeAttrsList = attrsList:
      #     lib.attrsets.foldAttrs
      #     (item: acc: lib.attrsets.recursiveUpdate acc item) { } attrsList;
      # };

      nixosConfigurations = lib.mapAttrs' (name: os: {
        inherit name;
        value = os._nixosConfiguration."${name}";
      }) cfg;

      # nixosConfigurations = lib.mapAttrs' (name: os: {
      #   inherit name;
      #   value = os._nixosConfiguration."${name}";
      # }) cfg;

      nixosModules = (lib.mapAttrs'
        (name: os: lib.nameValuePair "os@${name}" (import (./. + "/${name}")))
        cfg) // deepMergeAttrsList
        ((lib.mapAttrsToList (_: os: os._nixosUserModules)) cfg);
    };
  };
}
