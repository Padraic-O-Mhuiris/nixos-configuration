{ lib, pkgs, ... }:

{
  imports = [
    ../../_x.nix
    ../../_redshift.nix
    ./i3toggle.nix
    ./i3status.nix
    ./rofi.nix
    #./polybar
  ];
} // (lib.os.hm (user:
  { config, ... }: {
    xsession.windowManager.i3 =
      let modifier = config.xsession.windowManager.i3.config.modifier;
      in {
        enable = true;
        config = {
          modifier = "Mod4";
          terminal = config.home.sessionVariables.TERMINAL;
          menu = "rofi -show drun";
          keybindings = lib.mkOptionDefault {
            "${modifier}+Shift+q" = null;
            "${modifier}+Return" = null;
            "${modifier}+q" = "kill";
          };
          defaultWorkspace = "workspace number 1";
          gaps = {
            inner = 10;
            outer = 5;
            # smartBorders = "on";
            # smartGaps = true;
          };
          floating = {
            titlebar = false;
            border = 1;
          };
          window = {
            titlebar = false;
            border = 1;
          };
          bars = [ ];
        };
      };

    stylix.targets.i3.enable = true;

    home.packages = with pkgs; [ dmenu xdotool ];
  }))
