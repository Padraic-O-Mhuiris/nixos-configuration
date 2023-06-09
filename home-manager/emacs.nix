{ config, lib, pkgs, ... }:

{
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
    extraOptions = [ ];
  };
}
