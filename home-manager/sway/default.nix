{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk.enable = true;
    systemd.enable = true;
    config = rec {
      terminal = "alacritty";
      gaps.inner = 10;
      gaps.outer = 10;
    };
  };


  systemd.user.sessionVariables ={
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
