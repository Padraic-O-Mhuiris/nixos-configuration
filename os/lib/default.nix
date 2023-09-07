{ inputs }:

let
  inherit (inputs.nixpkgs) lib;

  inherit (lib) extend nixosSystem pathIsDirectory;

  inherit (lib.attrsets) mapAttrs filterAttrs;

  inherit (lib.options) mkOption;

  inherit (lib.asserts) assertMsg;

  inherit (lib.types) attrsOf submodule submoduleWith unspecified;

  # TODO Is there a better way of implementing this?
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

in
rec {
  utils = import ./utils.nix { inherit lib; };

  options = import ./options.nix { inherit lib pkgs validations; };

  validations = import ./validations.nix { inherit lib utils; };

  mkOsLib = { os }: import ./os.nix { inherit os lib utils; };

  # mkColorsModule = theme: import ./colors.nix { inherit theme; };

  mkLibForFlake = flakeConfig:
    lib.extend (_: prev:
      prev // {
        os = (mapAttrs (_: os: mkOsLib { inherit os; })
          flakeConfig.os.configuration) // {
          inherit options utils validations;
        };
      });

  mkOsSettingsOption = { configuration }:
    (mkOption {
      type = submodule ({ config, ... }: {
        options = {
          modulesPath = options.mkModulesPathOption;
          hostsPath = options.mkHostsPathOption configuration;
        };
        # config = {
        #   assertions = [
        #     (assertMsg (pathIsDirectory config.modulesPath)
        #       "modulesPath: ${config.modulesPath} does not exist")
        #     (assertMsg (pathIsDirectory config.hostsPath)
        #       "hostsPath: ${config.hostsPath} does not exist")
        #   ] ++ (utils.genHostAssertions {
        #     inherit (config) hostsPath;
        #     osConfig = utils.sanitizeOsConfig flakeConfig.os.configuration;
        #   });
        # };
      });
      description = "Os settings definition";
      # default = {
      #   modulesPath = options.modulesPathOption.default;
      #   hostsPath = options.hostsPathOption.default;
      # };
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
            (settings.hostsPath + "/${name}")
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              system.stateVersion = "23.05";
            }
            ../modules
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
