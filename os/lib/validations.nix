{ lib, utils }:

let
  inherit (lib)
    last throwIf pathExists pathIsDirectory hasAttr readDir flatten
    mapAttrsToList;

  inherit (utils) pathIsNixFile pathIsYamlFile genHostPaths;
in
rec {
  modulesPathDoc = ''
    The directory at modulesPath should contain a recursive file structure which is automatically imported. E.g:

    A file structure under modulesPath:

    modules/
    └─── apps/
        ├── mod1.nix
        └── mod2.nix

    This would be automatically imported into the flake os schema under `os.modules` as
    standard nixosModules which can then be imported as part of a NixOs configuration

    os.modules.apps = {
      mod1 = NixOs module
      mod2 = NixOs module
    }
  '';

  hostsPathDoc = ''
    The directory at hostsPath should only contain subdirectories named after each attrset key declared
    under the os.configuration data structure. E.g

    Given an os configuration like below:

    os.configuration = {
      host1 = { ... };
      host2 = { ... };
      host3 = { ... };
    };

    A file structure like so should be constructed:

    hosts
    ├── host1
    │   ├── default.nix
    │   ├── disko.nix
    │   └── secrets.yaml
    ├── host2
    │   ├── default.nix
    │   ├── disko.nix
    │   └── secrets.yaml
    └── host3
        ├── default.nix
        ├── disko.nix
        └── secrets.yaml
  '';

  validate = validations: path:
    last (map ({ cond, msg }: (throwIf cond msg path)) validations);

  hostValidations = { configuration, path }:
    flatten (map
      ({ host, hostDir, hostFilePath, diskoFilePath, secretsFilePath }: [
        {
          cond = !(pathIsDirectory hostDir);
          msg = ''
            ${
              toString hostDir
            } does not exist corresponding to os.configuration.${host} entry

            ${hostsPathDoc}
          '';
        }
        {
          cond = !(pathIsNixFile hostFilePath);
          msg = ''
            ${
              toString hostFilePath
            } does not exist corresponding to os.configuration.${host} entry

            ${hostsPathDoc}
          '';
        }
        {
          cond = !(pathIsNixFile diskoFilePath);
          msg = ''
            ${
              toString diskoFilePath
            } does not exist corresponding to os.configuration.${host} entry

            ${hostsPathDoc}
          '';
        }
        {
          cond = !(pathIsYamlFile secretsFilePath);
          msg = ''
            ${
              toString secretsFilePath
            } does not exist corresponding to os.configuration.${host} entry

            ${hostsPathDoc}
          '';

        }
      ])
      (mapAttrsToList (host: _: genHostPaths path host) configuration));

  mkHostsPathOptionApply = { configuration, path }:
    [
      {
        cond = !(pathExists path);
        msg = ''
          Hosts path: ${toString path} does not exist

          ${hostsPathDoc}
        '';
      }
      {
        cond = !(pathIsDirectory path);
        msg = ''
          Hosts path: ${toString path} is not a directory

          ${hostsPathDoc}
        '';
      }
    ] ++ (hostValidations configuration path);

  mkModulesPathOptionApply = { path }:
    (validate [
      {
        cond = !(pathExists path);
        msg = ''
          Modules path: ${toString path} does not exist

          ${modulesPathDoc}
        '';
      }
      {
        cond = !(pathIsDirectory path);
        msg = ''
          Modules path: ${toString path} is not a directory

          ${modulesPathDoc}
        '';
      }
      {
        cond = hasAttr "default.nix" (readDir path);
        msg = ''
          Modules path: ${
            toString path
          } must not contain a top-level default.nix

          ${modulesPathDoc}
        '';
      }
    ]
      path);
}
