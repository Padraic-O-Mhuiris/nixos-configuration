{ os, config, lib, pkgs, ... }:
let
  inherit (lib) mkOption mapAttrs' zipAttrs;

  inherit (lib.types) str listOf bool enum attrsOf submodule anything;

  inherit (lib.os.utils)
    base16ThemeNames base16ThemeAttrs defaultBase16MnemonicLabels
    generateBase16Mnemonic deepMergeAttrsList;

  mkColorOption = color:
    mkOption {
      type = str;
      default = color;
    };

  mkThemeOption = theme:
    let
      colors = generateBase16Mnemonic {
        inherit theme;
        labels = defaultBase16MnemonicLabels;
      };

      mnemonicColorOptions = mapAttrs' (k: v: {
        name = k;
        value = (mkOption {
          type = str;
          default = v;
          readOnly = true;
          internal = true;
        });
      }) (generateBase16Mnemonic {
        inherit theme;
        inherit (config.os.theme) labels;
      });

      base16ColorOptions = mapAttrs' (k: v: {
        name = k;
        value = (mkOption {
          type = str;
          default = v;
          readOnly = true;
          internal = true;
        });
      }) (base16ThemeAttrs theme);
    in {
      name = mkOption {
        type = str;
        default = theme;
      };
      foreground = mkOption {
        type = str;
        default = colors.pearl;
      };
      background = mkOption {
        type = str;
        default = colors.black;
      };
      primary = mkOption {
        type = str;
        default = colors.charcoal;
      };
      secondary = mkOption {
        type = str;
        default = colors.silver;
      };
      accent = mkOption {
        type = str;
        default = colors.white;
      };
      info = mkOption {
        type = str;
        default = colors.blue;
      };
      success = mkOption {
        type = str;
        default = colors.green;
      };
      warning = mkOption {
        type = str;
        default = colors.yellow;
      };
      error = mkOption {
        type = str;
        default = colors.red;
      };
    } // mnemonicColorOptions // base16ColorOptions;

in {
  options.os.theme = {
    labels = mkOption {
      type = listOf str;
      default = defaultBase16MnemonicLabels;
      description = ''
        Mnemonic labels which provide an ergonomic interface to accessing base16 colors
      '';
    };
    themes = deepMergeAttrsList
      (map (theme: { "${theme}" = mkThemeOption theme; }) base16ThemeNames);
    colors = mkThemeOption os.theme;
    fonts = { };
  };
}
