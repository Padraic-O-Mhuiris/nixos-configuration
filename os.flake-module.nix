{ lib, flake-parts-lib, self, config, inputs, ... }:

let
  cfg = config.os;
  l = lib // builtins;

  inherit (self.nixos-flake.lib) mkLinuxSystem;
in {
  options.os = l.mkOption {
    type = l.types.attrsOf (l.types.submodule ({ name, config, ... }: {
      options = {
        name = l.mkOption {
          type = l.types.str;
          description = "Name of the host";
          default = name;
        };

        # TODO If darwin is to be used
        # type = l.mkOption {
        #   type = l.types.enum [ "linux" "darwin" ];
        #   description = "Type of operating system";
        #   default = "linux";
        # };

        users = l.mkOption {
          type = l.types.listOf l.types.str;
          description = "users";
          default = [ ];
        };

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
      config = {
        _nixosConfiguration."${name}" = mkLinuxSystem ({ ... }: {

          imports =
            [ self.nixosModules."os@${name}" inputs.sops.nixosModules.sops ]
            ++ (l.flatten (l.map (user: [ self.nixosModules."user@${user}" ])
              config.users));

          sops.defaultSopsFile = ./os + "/${name}/secrets.yaml";
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
        (name: os: l.nameValuePair "os@${name}" (import (./os + "/${name}")))
        cfg;
    };

    os = {
      Oxygen = {
        users = [ "padraic" ];
        system = "x86_64-linux";
        ip = {
          local = "192.168.0.214";
          # remote = "192.168.0.214";
        };
      };
    };
  };
}
