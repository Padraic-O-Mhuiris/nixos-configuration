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

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in rec {
      # inherit (nixpkgs) lib;

      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in ((import ./pkgs { inherit pkgs; })) // {
          vm = pkgs.writeShellScriptBin "runVM" ''
            FILE=Hydrogen.qcow2
            if [ -f "$FILE" ]; then
               rm $FILE
            fi
            CMD=${nixosConfigurations.Hydrogen.config.system.build.vm}/bin/run-Hydrogen-vm
            exec $CMD -m 4096 -machine type=pc,accel=kvm -device virtio-vga-gl -display gtk,gl=on,grab-on-hover=on;
          '';
        });

      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; });

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;

      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        Hydrogen = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/Hydrogen/configuration.nix ];
        };

        Oxygen = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/Oxygen/configuration.nix ];
        };
      };
    };
}
