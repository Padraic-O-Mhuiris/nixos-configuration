{
  description = "NixOS Configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:NixOS/nixos-hardware";

    sops.url = "github:Mic92/sops-nix";

    flake-root.url = "github:srid/flake-root";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mission-control.url = "github:Platonic-Systems/mission-control";
    nixos-flake.url = "github:srid/nixos-flake";

    # hyprland.url = "github:hyprwm/Hyprland";

    emacs.url = "github:nix-community/emacs-overlay";

    nur.url = "github:nix-community/NUR";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:numtide/srvos";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.flake-root.flakeModule
        inputs.nixos-flake.flakeModule
        inputs.mission-control.flakeModule

        ./user.flake-module.nix
        ./os.flake-module.nix

        ./nixos
        ./home
      ];

      # flake = {
      #   nixosConfigurations = {
      #     Oxygen = self.nixos-flake.lib.mkLinuxSystem {
      #       imports = [
      #         self.nixosModules."user@padraic"
      #         ./systems/Oxygen/configuration.nix
      #       ];
      #     };
      #   };
      # };
    };

  # let
  #   inherit (self) outputs;
  #   forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
  # in {
  #   packages = forAllSystems (system:
  #     let pkgs = nixpkgs.legacyPackages.${system};
  #     in (import ./pkgs { inherit pkgs; }));

  #   devShells = forAllSystems (system:
  #     let pkgs = nixpkgs.legacyPackages.${system};
  #     in import ./shell.nix { inherit pkgs; });

  #   overlays = import ./overlays { inherit inputs; };

  #   formatter =
  #     forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

  #   nixosModules = import ./modules/nixos;

  #   homeManagerModules = import ./modules/home-manager;

  #   nixosConfigurations = {
  #     Hydrogen = nixpkgs.lib.nixosSystem {
  #       specialArgs = { inherit inputs outputs; };
  #       system = "x86_64-linux";
  #       modules = [ ./nixos/Hydrogen/configuration.nix ];
  #     };

  #     Oxygen = nixpkgs.lib.nixosSystem {
  #       specialArgs = { inherit inputs outputs; };
  #       system = "x86_64-linux";
  #       modules = [ ./nixos/Oxygen/configuration.nix ];
  #     };

  #   };
  # };
}
