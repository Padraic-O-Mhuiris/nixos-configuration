{ inputs, config, lib, pkgs, ... }:

{

  services.xserver = {
    enable = true;
    xserver = {
      enable = true;
      displayManager.defaultSession = "Hyprland";
      displayManager.sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        autoNumlock = true;
      };
    };
  };

  environment.sessionVariables = {

    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
