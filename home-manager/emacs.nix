{ config, lib, pkgs, ... }:

{
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
    client = true;
    defaultEditor = true;
    socketActivation = true;
  };
}
