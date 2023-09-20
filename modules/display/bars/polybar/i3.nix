{ lib, ... }:

(lib.os.hm (user: {
  services.polybar.settings."module/i3" = {
    type = "internal/i3";
    pin-workspaces = true;
    show-urgent = true;
    enable-click = true;

    label-mode = "%mode%";
    label-mode-padding = 2;
    label-mode-background = lib.os.colors.black;

    label-focused = "%index%";
    label-focused-foreground = lib.os.colors.yellow;
    label-focused-background = lib.os.colors.charcoal;
    label-focused-underline = lib.os.colors.yellow;
    label-focused-padding = 1;

    label-unfocused = "%index%";
    label-unfocused-padding = 1;

    label-visible = "%index%";
    label-visible-underline = lib.os.colors.pearl;
    label-visible-padding = 1;

    label-urgent = "%index%";
    label-urgent-foreground = lib.os.colors.white;
    label-urgent-background = lib.os.colors.red;
    label-urgent-padding = 1;

    label-separator = "◦";
    label-separator-padding = 0;
    label-separator-foreground = lib.os.colors.silver;
  };
}))
