{ config, lib, pkgs, inputs, ... }:

(lib.os.hm (user:
  let emacsPkg = pkgs.emacs-unstable;
  in {
    programs.emacs = {
      package = emacsPkg;
      enable = true;
    };

    services.emacs = {
      package = emacsPkg;
      enable = true;
      client.enable = true;
      defaultEditor = true;
      startWithUserSession = true;
      extraOptions = [ ];
    };

    home.packages = with pkgs; [
      (ripgrep.override { withPCRE2 = true; })
      fd
      aspell
      rust-analyzer
      nixfmt
      nil
    ];
  })) // {
    nixpkgs.overlays = [ inputs.emacs.overlay inputs.nil.overlays.default ];
  }
