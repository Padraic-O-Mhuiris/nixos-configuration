{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      main = {
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "clock" ];
        "sway/window" = {
          max-length = 50;
        };
        clock = {
          "format-alt" = "{:%a, %d. %b  %H:%M}";
        };
      };
    };
    style = '''';
  };
}
