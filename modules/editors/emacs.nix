{ config, lib, pkgs, inputs, ... }:

let emacsPkg = pkgs.emacs-unstable;
in (lib.os.applyHmUsers (user: {
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
})) // {
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];
}
