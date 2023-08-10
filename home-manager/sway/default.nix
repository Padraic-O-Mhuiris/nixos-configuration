{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

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
      modifier = "Mod4";
      terminal = "alacritty";
      input = {
        "*" = {
             xkb_layout= "gb";
             xkb_options="ctrl:nocaps,ctrl:swapcaps";
        };
      };
    };
  };

  # home.packages = with pkgs; [
  #   alacritty
  #   configure-gtk
  #   xdg-utils
  #   glib
  #   swaylock
  #   swayidle
  #   grim
  #   slurp
  #   wl-clipboard
  #   bemenu
  #   mako
  #   wdisplays
  # ];

}
