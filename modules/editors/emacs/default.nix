{ config, lib, pkgs, inputs, ... }:

let
  package = pkgs.emacsWithPackagesFromUsePackage {
    config = ""; # We don't want to create a default.el file
    defaultInitFile = pkgs.writeText "default.el" (builtins.readFile ./init.el);
    package = pkgs.emacs-unstable.override { withGTK3 = true; };
    extraEmacsPackages = epkgs:
      with epkgs; [
        use-package
        evil
        evil-collection
        general
        which-key
        command-log-mode
        ivy
        ivy-rich
        counsel
        swiper
        doom-modeline
        doom-themes
        all-the-icons
        rainbow-delimiters
        helpful
        hydra
        projectile
        counsel-projectile
        magit
        org
        # forge # - is this used?
        # (treesit-grammars.with-grammars
        #   (g: with g; [ tree-sitter-rust tree-sitter-python ]))
      ];
  };
in (lib.os.hm (user: {
  programs.emacs = {
    inherit package;
    enable = true;
  };

  services.emacs = {
    inherit package;
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
    extraOptions = [ ];
  };

  home.packages = with pkgs;
    [
      (ripgrep.override { withPCRE2 = true; })
      # shellcheck
      # shfmt
      # pandoc
      # fd
      # (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      # emacsPackages.editorconfig
      # terraform
      # graphviz
      # maim
      # solc
      # html-tidy
      # nodePackages_latest.stylelint
      # nodePackages_latest.js-beautify
      # nixfmt
    ];

  stylix.targets.emacs.enable = true; # TODO Figure out how to import!
})) // {
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];
}
