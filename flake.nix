{
  description = "NixOS Configuration";

  inputs = {
    base16.url = "github:SenchoPens/base16.nix";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

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

    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = import systems;
      imports = [ ./os ];
      flake.os = import ./os.nix;
    };
}
