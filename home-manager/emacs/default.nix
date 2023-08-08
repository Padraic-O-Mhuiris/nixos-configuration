{ inputs, config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = inputs.doom-emacs.packages.${config.system}.doom-emacs.override {
      doomPrivateDir = ./doom.d;
      emacsPackage = pkgs.emacs29-pgtk;
    };
    client.enable = true;
    defaultEditor = false;
    socketActivation.enable = true;
    extraOptions = [ ];
  };
}
