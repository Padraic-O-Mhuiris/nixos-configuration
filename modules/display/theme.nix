{ os, inputs, config, lib, pkgs, ... }:

let
  base16Scheme = "${pkgs.base16-schemes}/share/themes/${os.theme}.yaml";
  image = pkgs.runCommand "image.png" { } ''
    COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${base16Scheme})
    COLOR="#"$COLOR
    ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out'';
in {
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    inherit base16Scheme image;
    # autoEnable = true;
    polarity = "dark";
    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };
  };

  stylix.targets.gtk.enable = true;
  stylix.targets.gnome.enable = true;
} // (lib.os.hm (_: {
  stylix.targets.gtk.enable = true;
  stylix.targets.gnome.enable = true;
}))
