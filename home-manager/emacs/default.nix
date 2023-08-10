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
    # inputs.doom-emacs.packages.${pkgs.system}.default.override {
    #   doomPrivateDir = ./.;
    #   # emacsPackage = pkgs.emacs29-pgtk;
    #   emacsPackage = pkgs.emacsPgtkNativeComp;
    # };
    client.enable = true;
    defaultEditor = false;
    socketActivation.enable = true;
    extraOptions = [ ];
  };

  home.packages = with pkgs; [ beancount ];
}
