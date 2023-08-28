{ lib, pkgs, ... }:

lib.os.applyHmUsers (user:
  { config, ... }: {
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.i3 = {
        enable = true;
        config = {
          modifier = "Mod4";
          terminal = config.home.sessionVariables.TERMINAL;
          menu = "rofi -modi drun,run -show drun";
          keybindings = let
            modifier = config.xsession.windowManager.i3.config.modifier;
            terminal = config.xsession.windowManager.i3.config.terminal;
          in {
            "${modifier}+Shift+q" = null;
            "${modifier}+q" = "kill";
          };
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
    home.packages = with pkgs; [ rofi i3status ];
  }) // {
    services.xserver = {
      enable = true;
      desktopManager.session = [{
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }];
      displayManager.defaultSession = "home-manager";
    };

    environment.systemPackages = with pkgs; [ xorg.xdpyinfo ];
  }
