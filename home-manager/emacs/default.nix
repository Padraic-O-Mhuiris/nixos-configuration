{ inputs, config, lib, pkgs, system, ... }:

let
  emacsPkg = pkgs.emacs-unstable-pgtk;
in
{
  programs.emacs = {
    enable = true;
    package = emacsPkg;
  };

  services.emacs = {
    enable = true;
    package = emacsPkg;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
    extraOptions = [ ];
  };

  home.packages = with pkgs; [ beancount ];
}
