{ inputs, config, lib, pkgs, ... }:

lib.os.applyHmUsers
  ({ name, ... }:
    let
      cursorSettings = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        size = 32;
      };

    in
    {
      home = {
        packages = with pkgs; [ dconf ];
        pointerCursor = cursorSettings;
      };
    }) // (
  let

    color1 = "grayscale-light";
    color2 = "nord";
    theme = "${pkgs.base16-schemes}/share/themes/${color2}.yaml";
    wallpaper = pkgs.runCommand "image.png" { } ''
      COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${theme})
      COLOR="#"$COLOR
      ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out'';
  in
  {

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        corefonts
        # iosevka
        ubuntu_font_family
        dejavu_fonts
        liberation_ttf
        roboto
        fira-code
        jetbrains-mono
        siji
        font-awesome
        cascadia-code
        (nerdfonts.override { fonts = [ "Iosevka" ]; })
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "Iosevka NFP SemiBold" ];
          sansSerif = [ "Roboto" ];
          serif = [ "Roboto" ];
        };
      };
    };

    # console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  }
)
