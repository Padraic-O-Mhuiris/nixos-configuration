{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

# #!/bin/bash
# sleep 1
# killall -e xdg-desktop-portal-hyprland
# killall -e xdg-desktop-portal-wlr
# killall xdg-desktop-portal
# /usr/lib/xdg-desktop-portal-hyprland &
# sleep 2
# /usr/lib/xdg-desktop-portal &

let
  monitor = ''
    monitor=DP-1,5120x1440@60,0x0,1.1
  '';
  input = ''
    input {
      kb_layout = gb
      kb_options = ctrl:nocaps
      follow_mouse = 1
      sensitivity = 0
    }
  '';
  autostart = ''
    exec-once = waybar
  '';
  misc = ''
    misc {
      disable_autoreload = true
      animate_mouse_windowdragging = false
      vrr = 1
    }
  '';
  decoration = ''
    decoration {
        rounding = 16
        blur = true
        blur_size = 3
        blur_passes = 3
        blur_new_optimizations = true

        drop_shadow = true
        shadow_ignore_window = true
        shadow_offset = 0 5
        shadow_range = 50
        shadow_render_power = 3
        col.shadow = rgba(00000099)
      }
  '';
  env = ''
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_QPA_PLATFORM,wayland;xcb
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = GDK_BACKEND=wayland,x11
    env = HYPRLAND_LOG_WLR,1
  '';
  binds = ''
    $mod = SUPER

    bind = $mod, Return, exec, alacritty
    bind = $mod, Q, killactive,
    bind = $mod, M, exit,
    bind = $mod, E, exec, dolphin
    bind = $mod, V, togglefloating
    bind = $mod, F, fullscreen
    bind = $mod, D, exec, rofi -show drun
    bind = $mod, P, pseudo, # dwindle
    bind = $mod, J, togglesplit, # dwindle

    # Move focus with mod + arrow keys
    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d

    # Switch workspaces with mod + [0-9]
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    # Move active window to a workspace with mod + SHIFT + [0-9]
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mod + scroll
    bind = $mod, mouse_down, workspace, e+1
    bind = $mod, mouse_up, workspace, e-1

    # Move/resize windows with mod + LMB/RMB and dragging
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow
  '';
in {

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = true;
    extraConfig = ''
      ${monitor}
      ${autostart}
      ${misc}
      ${decoration}
      ${env}
      ${input}
      ${binds}
    '';
  };

  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    waybar
    libsForQt5.dolphin
    alacritty
    rofi-wayland
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
  ];

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

}
