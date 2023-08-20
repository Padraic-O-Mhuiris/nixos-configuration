{ flake-parts-lib, self, config, inputs, ... }:

let
  cfg = config.flake.os;

  libFactory = (import ./lib { inherit (inputs.nixpkgs) lib; });

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
          type = lib.types.str;
          description = "List of user ssh keys, first is primary";
          default = "";
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

  osSubmodule = lib.types.attrsOf (lib.types.submodule ({ name, config, ... }: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the host";
        default = name;
      };

      users = userFlakeSubmodule;

      cpu = lib.mkOption {
        type = lib.types.enum [ "amd" "intel" ];
        description = "cpu";
        default = "intel";
      };

      system = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "system";
        default = null;
      };

      disks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Disks of machine listed under /dev/disk/by-id/";
        default = [ ];
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

      _nixosConfiguration = lib.mkOption {
        internal = true;
        type = lib.types.unspecified;
        default = null;
      };
    };

    config = let
      lib = libFactory.mkLibForNixosConfiguration {
        os = name;
        osCfg = config;
      };

      specialArgs = {
        inherit lib inputs;
        os = config // { inherit (cfg) nixosModules homeModules; };
      };

      stateVersion = "23.05";
      homeManagerModules = [
        inputs.home-manager.nixosModules.home-manager
        ({
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
        })
      ];

      modules = [
        (./os + "/${name}")
        {
          networking.hostName = name;
          nixpkgs.hostPlatform = config.system;
          system = { inherit stateVersion; };
        }
      ] ++ homeManagerModules;
    in {
      _nixosConfiguration."${name}" =
        lib.nixosSystem { inherit specialArgs modules; };
    };
  }));

  lib = libFactory.mkLibForFlake cfg;
in {
  options.flake = {
    os = (lib.mkOption {
      type = osSubmodule;
      default = { };
      apply = (x:
        x // {
          nixosModules = lib.utils.moduleAttrsByPath ./nixos;
          homeModules = lib.utils.moduleAttrsByPath ./home;
        });
      description = "Attrset of os definitions";
    });
  };

  config.flake = let
    nixosConfigurations =
      lib.attrsets.mapAttrs (name: os: os._nixosConfiguration."${name}")
      (lib.filterAttrs (k: v: k != "nixosModules" && k != "homeModules") cfg);
  in { inherit lib nixosConfigurations; };
}
