{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.srvos.common
    inputs.srvos.mixins.trusted-nix-caches
    inputs.nix-ld.nixosModules.nix-ld
  ];

  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.master-packages
      inputs.emacs.overlays.default
      inputs.nur.overlay
    ];
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
      allowed-users = [ "@wheel" ];
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  programs.nix-ld.dev.enable = true;

  environment.systemPackages = with pkgs; [ cachix ];
}
