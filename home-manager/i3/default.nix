{ config, lib, pkgs, ... }:

{
  xsession = {
    enable = true;
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
}
