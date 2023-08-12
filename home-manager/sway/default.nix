{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

let
  inherit (config.wayland.windowManager.sway.config) modifier terminal menu left right up down;

  keybindings = {
    "${modifier}+Return" = "exec ${terminal}";
    "${modifier}+q" = "kill";
    "${modifier}+d" = "exec ${menu}";

    "${modifier}+${left}" = "focus left";
    "${modifier}+${down}" = "focus down";
    "${modifier}+${up}" = "focus up";
    "${modifier}+${right}" = "focus right";
    "${modifier}+Left" = "focus left";
    "${modifier}+Down" = "focus down";
    "${modifier}+Up" = "focus up";
    "${modifier}+Right" = "focus right";

    "${modifier}+Shift+${left}" = "move left";
    "${modifier}+Shift+${down}" = "move down";
    "${modifier}+Shift+${up}" = "move up";
    "${modifier}+Shift+${right}" = "move right";
    "${modifier}+Shift+Left" = "move left";
    "${modifier}+Shift+Down" = "move down";
    "${modifier}+Shift+Up" = "move up";
    "${modifier}+Shift+Right" = "move right";

    "${modifier}+b" = "splith";
    "${modifier}+v" = "splitv";
    "${modifier}+f" = "fullscreen toggle";
    "${modifier}+a" = "focus parent";

    "${modifier}+w" = "layout tabbed";
    "${modifier}+e" = "layout toggle split";

    "${modifier}+1" = "workspace number 1";
    "${modifier}+2" = "workspace number 2";
    "${modifier}+3" = "workspace number 3";
    "${modifier}+4" = "workspace number 4";
    "${modifier}+5" = "workspace number 5";
    "${modifier}+6" = "workspace number 6";
    "${modifier}+7" = "workspace number 7";
    "${modifier}+8" = "workspace number 8";
    "${modifier}+9" = "workspace number 9";

    "${modifier}+Shift+1" =
      "move container to workspace number 1";
    "${modifier}+Shift+2" =
      "move container to workspace number 2";
    "${modifier}+Shift+3" =
      "move container to workspace number 3";
    "${modifier}+Shift+4" =
      "move container to workspace number 4";
    "${modifier}+Shift+5" =
      "move container to workspace number 5";
    "${modifier}+Shift+6" =
      "move container to workspace number 6";
    "${modifier}+Shift+7" =
      "move container to workspace number 7";
    "${modifier}+Shift+8" =
      "move container to workspace number 8";
    "${modifier}+Shift+9" =
      "move container to workspace number 9";

    "${modifier}+Shift+minus" = "move scratchpad";
    "${modifier}+minus" = "scratchpad show";

    "${modifier}+Shift+c" = "reload";
    "${modifier}+Shift+e" =
      "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

    "${modifier}+r" = "mode resize";
  };
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraOptions = [
      "--verbose"
      "--debug"
      "--unsupported-gpu"
    ];
    config = rec {
      inherit keybindings;

      modifier = "Mod4";
      terminal = "alacritty";
      gaps.smartBorders = "on";
      gaps.smartGaps = true;

      defaultWorkspace = "workspace number 1";
      workspaceAutoBackAndForth = true;
      workspaceOutputAssign = [
        {
          output = "DP-1";
          workspace = "1";
        }
        {
          output = "HDMI-A-1";
          workspace = "2";
        }
      ];

      window = {
        titlebar = false;
        border = 3;
      };

      input = {
        "*" = {
          xkb_layout = "gb";
          xkb_options = "ctrl:nocaps,ctrl:swapcaps";
        };
      };
      output = {
        "DP-1" = {
          mode = "5120x1440@59.977Hz";
          pos = "0 0";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60Hz";
          pos = "5120 0";
          transform = "270";
        };
      };
    };
    extraConfig = ''
      set $term ${terminal}
      set $ddterm-id dropdown-terminal
      set $ddterm $term --class $ddterm-id
      set $ddterm-resize resize set 60ppt 80ppt, move position center

      for_window [app_id="$ddterm-id"] {
        floating enable
        $ddterm-resize
        move to scratchpad
        scratchpad show
      }

      bindsym Mod4+x exec swaymsg '[app_id="$ddterm-id"] scratchpad show' \
        || $ddterm \
        && sleep .1 && swaymsg '[app_id="$ddterm-id"] $ddterm-resize'

      set $ddEditor-id emacs
      set $ddEditor-resize resize set 60ppt 80ppt, move position center

      for_window [app_id="$ddEditor-id"] {
        floating enable
        $ddEditor-resize
        move to scratchpad
        scratchpad show
      }

      bindsym Mod4+z exec swaymsg '[app_id="$ddEditor-id"] scratchpad show' \
        || $EDITOR \
        && sleep .1 && swaymsg '[app_id="$ddEditor-id"] $ddEditor-resize'
    '';
  };
}
