{ pkgs ? (import ../nixpkgs.nix) { } }: {
  addSystemSecret = pkgs.writeShellScriptBin "addSystemSecret" ''
    SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key <<< $(${pkgs.pass}/bin/pass show ssh/id_ed25519)) EDITOR=${pkgs.vim}/bin/vim ${pkgs.sops}/bin/sops $1
  '';
}
