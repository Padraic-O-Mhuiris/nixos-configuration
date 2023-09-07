{ inputs, config, lib, pkgs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs =
    lib.extend (_: prev: prev // inputs.home-manager.lib);
} // (lib.os.hm (user: {
  home = {
    inherit (config.system) stateVersion;
    enableNixpkgsReleaseCheck = true;
    homeDirectory = "/home/${user.name}";
  };
}))
