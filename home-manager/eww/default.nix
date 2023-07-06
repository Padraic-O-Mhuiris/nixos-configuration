{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [ eww-wayland coreutils-full socat jq python39Full ];

  home.configFile."eww/eww.yuck".source = ./eww.yuck;
  home.configFile."eww/scripts/change-active-workspace".source = ./change-active-workspace;
  home.configFile."eww/scripts/get-active-workspace".source = ./get-active-workspace;
  home.configFile."eww/scripts/get-workspaces".source = ./get-workspaces;
  home.configFile."eww/scripts/get-window-title".source = ./get-window-title;

}
