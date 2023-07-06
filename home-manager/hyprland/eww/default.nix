{ inputs, lib, config, pkgs, ... }:

let
  scripts = {
    workspace = pkgs.writeShellScriptBin "workspace" ''
      #! /bin/bash

      #define icons for workspaces 1-9
      ic=(0 Term Browser Files Music Videos CS:GO Other)

      #initial check for occupied workspaces
      for num in $(hyprctl workspaces | grep ID | sed 's/()/(1)/g' | awk 'NR>1{print $1}' RS='(' FS=')'); do
        export o"$num"="$num"
      done

      #initial check for focused workspace
      for num in $(hyprctl monitors | grep active | sed 's/()/(1)/g' | awk 'NR>1{print $1}' RS='(' FS=')'); do
        export f"$num"="$num"
        export fnum=f"$num"
      done

      workspaces() {
      if [[ ''${1:0:9} == "workspace" ]]; then #set focused workspace
        unset -v "$fnum"
        num=''${1:11}
        export f"$num"="$num"
        export fnum=f"$num"

      elif [[ ''${1:0:15} == "createworkspace" ]]; then #set Occupied workspace
        num=''${1:17}
        export o"$num"="$num"
        export f"$num"="$num"

      elif [[ ''${1:0:16} == "destroyworkspace" ]]; then #unset unoccupied workspace
        num=''${1:18}
        unset -v o"$num" f"$num"
      fi

      #output eww widget
      echo "(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
                (box :class \"works\" :orientation \"h\" :spacing 5 :space-evenly \"true\"  \
                    (button :onclick \"hyprctl dispatch workspace 1\" :onrightclick \"hyprctl dispatch workspace 1 :class \"0$o1$f1\" \"''${ic[1]}\") \
                    (button :onclick \"hyprctl dispatch workspace 2\" :onrightclick \"hyprctl dispatch workspace 2 :class \"0$o2$f2\" \"''${ic[2]}\") \
                    (button :onclick \"hyprctl dispatch workspace 3\" :onrightclick \"hyprctl dispatch workspace 3 :class \"0$o3$f3\" \"''${ic[3]}\") \
                    (button :onclick \"hyprctl dispatch workspace 4\" :onrightclick \"hyprctl dispatch workspace 4 :class \"0$o4$f4\" \"''${ic[4]}\") \
                    (button :onclick \"hyprctl dispatch workspace 5\" :onrightclick \"hyprctl dispatch workspace 5 :class \"0$o5$f5\" \"''${ic[5]}\") \
                    (button :onclick \"hyprctl dispatch workspace 6\" :onrightclick \"hyprctl dispatch workspace 6 :class \"0$o6$f6\" \"''${ic[6]}\") \
                    (button :onclick \"hyprctl dispatch workspace 7\" :onrightclick \"hyprctl dispatch workspace 7 :class \"0$o7$f7\" \"''${ic[7]}\") \
                )\
              )"
      }

      workspaces

      socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do
      workspaces "$event"
      done

    '';
  };

  time = ''
    ;; ━━━ TIME ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    (defpoll timeVar :interval "1s" "date '+%H:%M:%S | %A | %d %h %y'")

    (defwidget time []
      (box "''${timeVar}"))
  '';

  audio = ''
    (defpoll volumeSpeaker :interval "999h" :initial 0 `pamixer --get-volume`)
    (defpoll volumeMic :interval "999h" :initial 0 `pamixer --get-volume --source 1`)

    (defwidget audio []
      (box
        (scale :min 1 :max 101 :width 315 :class "micvolume_slider" :value volumeMic :onchange "pamixer --set-volume $(echo {} | sed 's/[.].*$//') --source 1")
      ))
  '';

  workspaces = ''
    (deflisten workspace "${scripts.workspace}/bin/workspace")
    (defwidget workspaces [] (literal :content workspace))
  '';

  bar = ''
    ${audio}
    ${time}
    ${workspaces}

    (defwindow bar
               :monitor 0
               :geometry (geometry :x "0%"
                                   :y "0%"
                                   :width "80%"
                                   :height "2%"
                                   :anchor "top center")
               :exclusive true
               :focusable false
      (centerbox :orientation "h"
        (workspaces)
        (time)
        (box "jjbnj")
      ))
  '';
in
{
  # eww package
  home.packages = with pkgs; [
    eww-wayland
    pamixer
  ];

  # configuration
  home.file.".config/eww/eww.scss".text = ''

  '';

  home.file.".config/eww/eww.yuck".text = ''
    ${bar}
  '';

  # # scripts
  # home.file.".config/eww/scripts/battery.sh" = {
  #   source = ./scripts/battery.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/wifi.sh" = {
  #   source = ./scripts/wifi.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/brightness.sh" = {
  #   source = ./scripts/brightness.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/workspaces.sh" = {
  #   source = ./scripts/workspaces.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/workspaces.lua" = {
  #   source = ./scripts/workspaces.lua;
  #   executable = true;
  # };
}
