{ lib, pkgs, ... }:

{
  imports = [ ../../_x.nix ./i3toggle.nix ];
} // (lib.os.hm (user:
  { config, ... }: {
    xsession.windowManager.i3 = let modifier = "Mod4";
    in {
      enable = true;
      config = {
        inherit modifier;
        terminal = config.home.sessionVariables.TERMINAL;
        menu = config.home.sessionVariables.APPS_LAUNCHER;
        keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+q" = null;
          "${modifier}+Return" =
            "exec ${config.xsession.windowManager.i3.config.terminal}";
          "${modifier}+q" = "kill";
        };
        defaultWorkspace = "workspace number 1";
        gaps = {
          inner = 10;
          outer = 5;
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
