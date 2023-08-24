{
  description = "NixOS Configuration";

  inputs = {

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:NixOS/nixos-hardware";

    emacs.url = "github:nix-community/emacs-overlay";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-anywhere.url = "github:numtide/nixos-anywhere";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    nix-ld.url = "github:Mic92/nix-ld";

    nur.url = "github:nix-community/NUR";

    sops.url = "github:Mic92/sops-nix";

    srvos.url = "github:numtide/srvos";

  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ ./os.flake-module.nix ./os ./packages ];
      flake = { inherit inputs; };
    };
}
