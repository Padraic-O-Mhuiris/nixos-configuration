{ config, lib, pkgs, ... }:

(lib.os.hm (user:
  { config, ... }: {
    services.polybar.settings."module/i3" = {
      module.i3 = {
        type = "internal/i3";
        pin-workspaces = true;
        show-urgent = true;
        enable-click = true;

        label-mode = "%mode%";
        label-mode-padding = 2;
        label-mode-background = colors.background;

        label-focused = "%index%";
        label-focused-foreground = colors.yellow;
        label-focused-background = colors.background;
        label-focused-underline = colors.yellow;
        label-focused-padding = 1;

        label-unfocused = "%index%";
        label-unfocused-padding = 1;

        label-visible = "%index%";
        label-visible-underline = colors.white;
        label-visible-padding = 1;

        label-urgent = "%index%";
        label-urgent-foreground = colors.black;
        label-urgent-background = colors.red;
        label-urgent-padding = 1;

        label-separator = "◦";
        label-separator-padding = 0;
        label-separator-foreground = colors.foreground;
      };
    };
  }))
