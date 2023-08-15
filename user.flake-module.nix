{ lib, flake-parts-lib, self, config, inputs, ... }:

let cfg = config.user;
in {
  options.user = lib.mkOption {
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

        _nixosModule = lib.mkOption {
          internal = true;
          type = lib.types.unspecified;
          default = null;
        };

        _homeModule = lib.mkOption {
          internal = true;
          type = lib.types.unspecified;
          default = null;
        };

        # TODO Extend to a home configuration
        # _homeConfiguration = lib.mkOption {
        #   internal = true;
        #   type = lib.types.unspecified;
        #   default = null;
        # };
      };

      config = {
        _nixosModule."${name}" = ({ ... }: {
          imports = [ self.nixosModules.home-manager ];

          #'sops.secrets."user@${name}" = { neededForUsers = true; };

          users.users.${name} = {
            home = "/home/${name}";
            isNormalUser = true;
            openssh.authorizedKeys.keys = [ config.ssh ];
            passwordFile = config.sops.secrets."user@${name}".path;
            uid = 1000;
            extraGroups = [ "wheel" "audio" "video" ];
          };

          home-manager.users.${name} = { pkgs, ... }: {
            imports = [
              self.homeModules."user@${name}"
              # TODO self.homeModules.common
            ];
          };
        });
        _homeModule = {
          ${name} = ({ ... }: {
            programs = {
              git = {
                userEmail = config.email;
                userName = config.github;
                signing.key = config.gpg.fingerprint;
              };
              gpg.publicKeys = [{
                text = config.gpg.key;
                trust = 5;
              }];
              password-store.settings.PASSWORD_STORE_KEY =
                config.gpg.fingerprint;
            };
          });
        };
      };
    }));
    default = { };
    description = "Attrs of user definitions";
  };

  config = {
    flake = {
      nixosModules = lib.mapAttrs'
        (name: user: lib.nameValuePair "user@${name}" user._nixosModule.${name})
        cfg;
      homeModules = lib.mapAttrs'
        (name: user: lib.nameValuePair "user@${name}" user._homeModule.${name})
        cfg;
    };

    user = {
      padraic = {
        email = "patrick.morris.310@gmail.com";
        github = "Padraic-O-Mhuiris";
        ssh =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
        gpg.fingerprint = "8544725A91D4B87821522A368DA36F90B33A4605";
        gpg.key = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          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
          DFWRaOXkWFE=
          =AUzH
          -----END PGP PUBLIC KEY BLOCK-----
        '';
      };
    };

  };

}
