{ config, lib, pkgs, ... }:

lib.os.applyHmUsers
  (user: {
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.i3.config = {
        terminal = "alacritty";
        menu = "rofi -combi-modi window,drun,ssh -show combi";
        gaps = {
          inner = 10;
          outer = 10;
          smartBorders = "on";
          smartGaps = true;
        };
        window = {
          titlebar = false;
          border = 3;
        };
      };
    };

    home.packages = with pkgs; [ rofi i3status ];
  }) // {
  services.xserver = {
    enable = true;
    # windowManager.i3 = {
    #   enable = true;
    #   # configFile = "";
    # };
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
