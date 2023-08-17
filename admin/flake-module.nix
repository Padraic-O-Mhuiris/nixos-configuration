{ lib, config, self, inputs, ... }:

{
  perSystem = { pkgs, lib, config, ... }:
    let
      editSystemSecret = pkgs.writeShellScriptBin "addSystemSecret" ''
        SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show ssh/id_ed25519)) EDITOR=${pkgs.vim}/bin/vim ${pkgs.sops}/bin/sops $1
      '';

      rekeySystemSecret = pkgs.writeShellScriptBin "rekeySystemSecret" ''
        SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show ssh/id_ed25519)) EDITOR=${pkgs.vim}/bin/vim ${pkgs.sops}/bin/sops updatekeys $1
      '';
    in {
      mission-control.scripts = {
        fmt = {
          description = "Format the top-level Nix files";
          exec = "${lib.getExe pkgs.nixpkgs-fmt} ./*.nix";
          category = "Tools";
        };
      };
      devShells.default = pkgs.mkShell {
        NIX_CONFIG = "experimental-features = nix-command flakes";
        inputsFrom = [ config.mission-control.devShell ];
        nativeBuildInputs = with pkgs; [ home-manager git nixpkgs-fmt ];
      };
    };
}
