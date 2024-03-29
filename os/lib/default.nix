{ inputs }:

let
  inherit (inputs.nixpkgs) lib;

  inherit (lib) extend nixosSystem pathIsDirectory;

  inherit (lib.attrsets) mapAttrs filterAttrs;

  inherit (lib.options) mkOption;

  inherit (lib.asserts) assertMsg;

  inherit (lib.types) attrsOf submodule submoduleWith unspecified;

in rec {
  utils = import ./utils.nix { inherit inputs lib; };

  options = import ./options.nix { inherit lib utils validations; };

  validations = import ./validations.nix { inherit lib utils; };

  mkOsLib = { os }: import ./os.nix { inherit os lib utils; };

  mkLibForFlake = flakeConfig:
    lib.extend (_: prev:
      prev // {
        os = (mapAttrs (_: os: mkOsLib { inherit os; })
          flakeConfig.os.configuration) // {
            inherit options validations;
          };
      });

  mkOsModulesOption = path:
    mkOption {
      type = unspecified;
      readOnly = true;
      default = utils.moduleAttrsByPath path;
    };

  mkOsConfigurationOption = { settings, modules }:
    mkOption {
      type = (attrsOf (submodule ({ name, config, ... }: {
        options = {
          name = options.mkNameOption name;
          users = options.usersOption;
          theme = options.themeOption;
          cpu = options.cpuOption;
          gpu = options.gpuOption;
          disks = options.disksOption;
          ip = options.ipOptions;
          _nixosConfiguration = options._nixosConfigurationOption;
        };
        config._nixosConfiguration = nixosSystem {
          specialArgs = {
            inherit inputs;
            lib = extend (_: prev: prev // { os = mkOsLib { os = config; }; });
            os = config // { inherit modules; };
          };
          modules = [
            { networking.hostName = name; }
            (settings.hostsPath + "/${name}")
            ../modules/home-manager.nix
            ../modules/nix.nix
            ../modules/colors.nix
          ];
        };
      })));
      default = { };
      description = "Os definition";
    };

  mkOsOption = flakeConfig: {
    configuration =
      mkOsConfigurationOption { inherit (flakeConfig.os) settings modules; };
    settings = {
      hostsPath = options.hostsPathOption;
      modulesPath = options.modulesPathOption;
    };
    modules = mkOsModulesOption flakeConfig.os.settings.modulesPath;
  };

  mkNixosConfigurations = { configuration, ... }:
    mapAttrs (_: { _nixosConfiguration, ... }: _nixosConfiguration)
    configuration;
}
