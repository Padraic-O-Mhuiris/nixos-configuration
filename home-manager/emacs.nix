{ config, lib, pkgs, ... }:

{
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
    client.enable = true;
    defaultEditor = false;
    socketActivation.enable = true;
    extraOptions = [ ];
  };
}
