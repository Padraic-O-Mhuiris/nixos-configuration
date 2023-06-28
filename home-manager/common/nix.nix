{ inputs, outputs, config, lib, pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.master-packages
      inputs.emacs.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
