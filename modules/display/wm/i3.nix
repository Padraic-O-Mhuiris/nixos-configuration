{ lib, pkgs, ... }:

{
  imports = [ ../_x.nix ];
} //
(lib.os.applyHmUsers (user:
  { config, ... }: {
    xsession = {
      windowManager.i3 = {
        enable = true;
        config = {
          modifier = "Mod4";
          terminal = config.home.sessionVariables.TERMINAL;
          menu = "rofi -show drun";
          keybindings =
            let modifier = config.xsession.windowManager.i3.config.modifier;
            in lib.mkOptionDefault {
              "${modifier}+Shift+q" = null;
              "${modifier}+q" = "kill";
            };
          defaultWorkspace = "workspace number 1";
          gaps = {
            inner = 5;
            outer = 5;
            smartBorders = "on";
            smartGaps = true;
          };
          window = {
            titlebar = false;
            border = 1;
          };
        };
      };
    };
    home.packages = with pkgs; [ rofi i3status dmenu ];
  })
)
