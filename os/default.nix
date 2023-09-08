{ config, inputs, ... }:

let
  inherit (import ./lib { inherit inputs; })
    mkNixosConfigurations mkLibForFlake mkOsOption;
in {
  options.flake.os = mkOsOption config.flake;

  config = {

    flake = {
      lib = mkLibForFlake config.flake;
      nixosConfigurations = mkNixosConfigurations config.flake.os;
    };

    perSystem = { pkgs, inputs', lib, ... }: {
      packages = {
        deployOxygen = pkgs.writeShellScriptBin "deployOxygen" ''
          temp=$(mktemp -d)

          cleanup() {
            rm -rf "$temp"
          }
          trap cleanup EXIT

          install -d -m755 "$temp/persist/etc/ssh"

          pass os/hosts/Oxygen/ssh_host_ed25519_key > "$temp/persist/etc/ssh/ssh_host_ed25519_key"
          pass os/hosts/Oxygen/ssh_host_ed25519_key.pub > "$temp/persist/etc/ssh/ssh_host_ed25519_key.pub"

          chmod 600 "$temp/persist/etc/ssh/ssh_host_ed25519_key"
          chmod 644 "$temp/persist/etc/ssh/ssh_host_ed25519_key.pub"

          ${lib.getExe inputs'.nixos-anywhere.packages.default} \
          --disk-encryption-keys /tmp/secret.key <(echo -n $(${
            lib.getExe pkgs.pass
          } show os/hosts/Oxygen/disk)) \
          --extra-files "$temp" \
          --build-on-remote \
          --no-reboot \
          --print-build-logs \
          --debug \
          --flake $HOME/code/nix/nixos-configuration#Oxygen root@${config.flake.os.configuration.Oxygen.ip.local}
        '';

        deployHydrogen = pkgs.writeShellScriptBin "deployHydrogen" ''
          temp=$(mktemp -d)

          cleanup() {
            rm -rf "$temp"
          }
          trap cleanup EXIT

          install -d -m755 "$temp/persist/etc/ssh"

          pass os/hosts/Hydrogen/ssh_host_ed25519_key > "$temp/persist/etc/ssh/ssh_host_ed25519_key"
          pass os/hosts/Hydrogen/ssh_host_ed25519_key.pub > "$temp/persist/etc/ssh/ssh_host_ed25519_key.pub"

          chmod 600 "$temp/persist/etc/ssh/ssh_host_ed25519_key"
          chmod 644 "$temp/persist/etc/ssh/ssh_host_ed25519_key.pub"

          ${lib.getExe inputs'.nixos-anywhere.packages.default} \
          --disk-encryption-keys /tmp/secret.key <(echo -n $(${
            lib.getExe pkgs.pass
          } show os/hosts/Hydrogen/disk)) \
          --extra-files "$temp" \
          --build-on-remote \
          --no-reboot \
          --print-build-logs \
          --debug \
          --flake $HOME/code/nix/nixos-configuration#Hydrogen root@${config.flake.os.configuration.Hydrogen.ip.local}
        '';

        editOxygenSecrets = pkgs.writeShellScriptBin "editOxygenSecrets" ''
          EDITOR=${pkgs.vim}/bin/vim \
          SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show os/users/padraic/id_ed25519)) \
          ${pkgs.sops}/bin/sops $HOME/code/nix/nixos-configuration/hosts/Oxygen/secrets.yaml
        '';

        rekeyOxygenSecrets = pkgs.writeShellScriptBin "rekeyOxygenSecrets" ''
          EDITOR=${pkgs.vim}/bin/vim \
          SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show os/users/padraic/id_ed25519)) \
          ${pkgs.sops}/bin/sops updatekeys $HOME/code/nix/nixos-configuration/hosts/Oxygen/secrets.yaml
        '';

        editHydrogenSecrets = pkgs.writeShellScriptBin "editHydrogenSecrets" ''
          EDITOR=${pkgs.vim}/bin/vim \
          SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show os/users/padraic/id_ed25519)) \
          ${pkgs.sops}/bin/sops $HOME/code/nix/nixos-configuration/hosts/Hydrogen/secrets.yaml
        '';

        rekeyHydrogenSecrets =
          pkgs.writeShellScriptBin "rekeyHydrogenSecrets" ''
            EDITOR=${pkgs.vim}/bin/vim \
            SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show os/users/padraic/id_ed25519)) \
            ${pkgs.sops}/bin/sops updatekeys $HOME/code/nix/nixos-configuration/hosts/Hydrogen/secrets.yaml
          '';

      };
    };
  };
}
