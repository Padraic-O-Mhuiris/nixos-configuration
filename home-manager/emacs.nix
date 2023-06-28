{ config, lib, pkgs, ... }:

{
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };
}
