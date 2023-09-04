{ inputs, config, lib, pkgs, ... }:

lib.os.applyHmUsers ({ name, ... }:
  let
    cursorSettings = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 32;
    };

  in {
    # stylix.targets.rofi.enable = true;
    # stylix.targets.i3.enable = true;
    # stylix.targets.bat.enable = true;
    # stylix.targets.feh.enable = true;
    # stylix.targets.gtk.enable = true;
    # stylix.targets.tmux.enable = true;

    home = {
      packages = with pkgs; [ dconf ];
      pointerCursor = cursorSettings;
    };

  }) // (let

    color1 = "grayscale-light";
    color2 = "nord";
    theme = "${pkgs.base16-schemes}/share/themes/${color2}.yaml";
    wallpaper = pkgs.runCommand "image.png" { } ''
      COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${theme})
      COLOR="#"$COLOR
      ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out'';
  in {

    # imports = [ inputs.stylix.nixosModules.stylix ];

    # stylix = {
    #   # autoEnable = true;
    #   homeManagerIntegration = {
    #     autoImport = true;
    #     followSystem = true;
    #   };

    #   base16Scheme = theme;
    #   image = wallpaper;
    #   fonts = {
    #     serif = config.stylix.fonts.sansSerif;
    #     sansSerif = {
    #       package = pkgs.roboto;
    #       name = "Roboto";
    #     };

    #     monospace = {
    #       package = pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; };
    #       name = "Iosevka NFP SemiBold";
    #     };

    #     emoji = {
    #       package = pkgs.noto-fonts-emoji;
    #       name = "Noto Color Emoji";
    #     };

    #     sizes = {
    #       terminal = 6;
    #       popups = 16;
    #       desktop = 10;
    #     };
    #   };
    # };

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
  })
