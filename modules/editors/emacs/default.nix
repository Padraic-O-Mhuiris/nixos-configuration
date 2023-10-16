{ config, lib, pkgs, inputs, ... }:

lib.os.hm (user: {
  # home.file.".emacs.d/init.el".source = ./init.el;
  programs.emacs = {
    package = inputs.emacs.packages.${pkgs.system}.default;
    enable = true;
  };

  # services.emacs = {
  #   package = inputs.emacs.packages.${pkgs.system}.default;
  #   enable = true;
  #   client.enable = true;
  #   defaultEditor = true;
  #   socketActivation.enable = true;
  #   extraOptions = [ ];
  # };

   # stylix.targets.emacs.enable = true; # TODO Figure out how to import!
})
