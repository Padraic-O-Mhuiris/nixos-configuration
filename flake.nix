{
  description = "NixOS Configuration";

  inputs = {
    base16.url = "github:SenchoPens/base16.nix";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:NixOS/nixos-hardware";

    emacs.url = "github:nix-community/emacs-overlay";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nixos-anywhere.url = "github:numtide/nixos-anywhere";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    nix-ld.url = "github:Mic92/nix-ld";

    nur.url = "github:nix-community/NUR";

    sops.url = "github:Mic92/sops-nix";

    srvos.url = "github:numtide/srvos";

    stylix.url = "github:danth/stylix";

    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = import systems;
      imports = [ inputs.devshell.flakeModule ./os ];
      flake = {
        inherit inputs;
        os = import ./os.nix;
      };

      perSystem = { config, pkgs, ... }: { devshells.default = { }; };
    };
}
