{ lib, flake-parts-lib, self, config, inputs, ... }:

let
  cfg = config.os;
  l = lib // builtins;

  inherit (self.nixos-flake.lib) mkLinuxSystem;

  # userSubmodule definition
  userFlakeSubmodule = l.mkOption {
    type = l.types.attrsOf (l.types.submodule ({ name, config, ... }: {
      options = {
        name = l.mkOption {
          type = l.types.str;
          description = "Name of the user";
          default = name;
        };

        email = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "Email of the user";
          default = null;
        };

        github = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "Github username of the user";
          default = null;
        };

        ssh = l.mkOption {
          type = l.types.nullOr l.types.strMatching
            "^(ssh-ed25519s+AAAAC3NzaC1lZDI1NTE5|sk-ssh-ed25519@openssh.coms+AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29t|ssh-rsas+AAAAB3NzaC1yc2)[0-9A-Za-z+/]+[=]{0,3}(s.*)?$";
          description = "List of user ssh keys, first is primary";
          default = null;
        };

        gpg.fingerprint = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "User gpg fingerprint";
          default = null;
        };

        gpg.key = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "User gpg key";
          default = null;
        };
      };

    }));
    default = { };
    description = "Attrs of user definitions";
  };

in {

  options.os = l.mkOption {
    type = l.types.attrsOf (l.types.submodule ({ name, config, ... }: {
      options = {
        name = l.mkOption {
          type = l.types.str;
          description = "Name of the host";
          default = name;
        };

        # modules = l.mkOption {
        #   type = l.types.listOf l.types.str;
        #   description =
        #     "List of home-manager modules defined in /home/default.nix";
        #   default = [ ];
        # };

        # homeModules = l.mkOption {
        #   type = l.types.listOf l.types.str;
        #   description =
        #     "List of home-manager modules defined in /home/default.nix";
        #   default = [ ];
        # };

        # TODO If darwin is to be used
        # type = l.mkOption {
        #   type = l.types.enum [ "linux" "darwin" ];
        #   description = "Type of operating system";
        #   default = "linux";
        # };

        users = userFlakeSubmodule;

        system = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "system";
          default = null;
        };

        ip.local = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "Local IP address of machine";
          default = null;
        };

        ip.remote = l.mkOption {
          type = l.types.nullOr l.types.str;
          description = "Local IP address of machine";
          default = null;
        };

        _nixosConfiguration = l.mkOption {
          internal = true;
          type = l.types.unspecified;
          default = null;
        };
      };
      config = let cfg = config;
      in {
        _nixosConfiguration."${name}" = mkLinuxSystem ({ ... }: {
          imports = [
            self.nixosModules."os@${name}"
            inputs.sops.nixosModules.sops

            # ({ config, ... }: {
            #   options.__os__.user = l.mkOption {
            #     type = lib.listOf
            #       (l.types.functionTo (lib.types.attrsOf l.types.anything));
            #     description = "";
            #     default = [ ];
            #   };
            #   config = l.attrsets.mergeAttrsList
            #     (l.map (fn: l.mapAttrsToList (k: v: (fn k v)) cfg.user)
            #       config.os.user.fn);
            # })

            # ({ config, ... }: {
            #   __os__.user = [
            #     (user: userConfig: {
            #       users.users.${user}.openssh.authorizedKeys.keys =
            #         [ userConfig.ssh ];
            #     })
            #   ];
            # })
          ];

          sops.defaultSopsFile = ./. + "/${name}/secrets.yaml";
          sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

          networking.hostName = name;
          nixpkgs.hostPlatform = config.system;
          system.stateVersion = "23.05";
        });
      };
    }));
    default = { };
    description = "Attrs of os definitions";
  };

  config = {
    flake = {
      nixosConfigurations = l.mapAttrs' (name: os: {
        inherit name;
        value = os._nixosConfiguration."${name}";
      }) cfg;

      nixosModules = l.mapAttrs'
        (name: os: l.nameValuePair "os@${name}" (import (./. + "/${name}")))
        cfg;
    };
  };
}
