{ self, inputs, ... }:

let

  inherit (self) os;

  inherit (inputs.nixpkgs) lib;

  inherit (lib) getExe;

  inherit (lib.strings) concatStringsSep toJSON;

  inherit (lib.attrsets) mapAttrsToList filterAttrs mapAttrs;

  inherit (lib.lists) map;

  hosts = (filterAttrs (host: _: host != "modules") os);

  hostNames = (mapAttrsToList (host: _: ''"${host}"'') hosts);

  hostAttrs =
    (mapAttrs (k: v: lib.filterAttrs (k: _: k != "_nixosConfiguration") v)
      hosts);

in {
  perSystem = { pkgs, inputs', ... }:
    let
      hostJsonFile = pkgs.writeTextFile {
        name = "os.json";
        text = "${toJSON hostAttrs}";
      };
    in {
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

          ${getExe inputs'.nixos-anywhere.packages.default} \
          --disk-encryption-keys /tmp/secret.key <(echo -n $(${
            lib.getExe pkgs.pass
          } show os/hosts/Oxygen/disk)) \
          --extra-files "$temp" \
          --build-on-remote \
          --no-reboot \
          --print-build-logs \
          --debug \
          --flake $HOME/code/nix/nixos-configuration#Oxygen root@${os.Oxygen.ip.local}
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

          ${getExe inputs'.nixos-anywhere.packages.default} \
          --disk-encryption-keys /tmp/secret.key <(echo -n $(${
            lib.getExe pkgs.pass
          } show os/hosts/Hydrogen/disk)) \
          --extra-files "$temp" \
          --build-on-remote \
          --no-reboot \
          --print-build-logs \
          --debug \
          --flake $HOME/code/nix/nixos-configuration#Hydrogen root@${os.Hydrogen.ip.local}
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
}
