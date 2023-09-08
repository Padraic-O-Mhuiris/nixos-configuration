{ config, lib, pkgs, inputs, ... }:

let emacsPkg = pkgs.emacs-unstable;
in (lib.os.hm (user: {
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

  home.packages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    shellcheck
    shfmt
    pandoc
    fd
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    emacsPackages.editorconfig
    terraform
    graphviz
    maim
    solc
    html-tidy
    nodePackages_latest.stylelint
    nodePackages_latest.js-beautify
    nixfmt
  ];

  stylix.targets.emacs.enable = true; # TODO Figure out how to import!
})) // {
  nixpkgs.overlays = [ inputs.emacs.overlays.default ];
}
