{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [ eww-wayland coreutils-full socat jq python39Full ];

  home.config."eww/eww.yuck".source = ./eww.yuck;
  home.config."eww/scripts/change-active-workspace".source = ./change-active-workspace;
  home.config."eww/scripts/get-active-workspace".source = ./get-active-workspace;
  home.config."eww/scripts/get-workspaces".source = ./get-workspaces;
  home.config."eww/scripts/get-window-title".source = ./get-window-title;

}
