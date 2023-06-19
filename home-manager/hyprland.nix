{ config, lib, pkgs, ... }:

let
  monitor = ''
    monitor=DP-1,5120x1440@60,0x0,1.1
  '';
  input = ''
    input {
      kb_layout = uk
      kb_model = pc104
      kb_options = ctrl:nocaps
      follow_mouse = 1
      sensitivity = 0
    }
  '';
  autostart = ''
    exec-once = dunst
    exec-once = waybar
  '';
  env = ''
    env = WLR_NO_HARDWARE_CURSORS,1
  '';
  binds = ''
    $mod = SUPER

    bind = $mod, Return, exec, alacritty
    bind = $mod, C, killactive,
    bind = $mod, M, exit,
    bind = $mod, E, exec, dolphin
    bind = $mod, V, togglefloating,
    bind = $mod, R, exec, wofi --show drun
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
      ${env}
      ${input}
      ${binds}
    '';
  };

  home.packages = with pkgs; [ dunst waybar wofi libsForQt5.dolphin alacritty ];

  # programs = { waybar = { }; };
}