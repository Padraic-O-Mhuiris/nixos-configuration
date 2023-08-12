{ inputs, config, lib, pkgs, ... }:

let
  i3Config = pkgs.writeTextFile {
    name = "i3Config";
    executable = true;
    destination = "/bin/i3Config";
    text = ''
      set $mod Mod4

      font pango:monospace 8

      set $refresh_i3status killall -SIGUSR1 i3status
      bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
      bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
      bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
      bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

      floating_modifier $mod

      bindsym $mod+q kill

      bindsym $mod+d exec --no-startup-id "rofi -modi drun,run -show drun"

      bindsym $mod+j focus left
      bindsym $mod+k focus down
      bindsym $mod+l focus up
      bindsym $mod+semicolon focus right

      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right

      bindsym $mod+Shift+j move left
      bindsym $mod+Shift+k move down
      bindsym $mod+Shift+l move up


      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      bindsym $mod+h split h

      bindsym $mod+v split v

      bindsym $mod+f fullscreen toggle

      bindsym $mod+s layout stacking
      bindsym $mod+w layout tabbed
      bindsym $mod+e layout toggle split

      bindsym $mod+Shift+space floating toggle

      bindsym $mod+space focus mode_toggle

      bindsym $mod+a focus parent

      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"

      bindsym $mod+1 workspace number $ws1
      bindsym $mod+2 workspace number $ws2
      bindsym $mod+3 workspace number $ws3
      bindsym $mod+4 workspace number $ws4
      bindsym $mod+5 workspace number $ws5
      bindsym $mod+6 workspace number $ws6
      bindsym $mod+7 workspace number $ws7
      bindsym $mod+8 workspace number $ws8
      bindsym $mod+9 workspace number $ws9
      bindsym $mod+0 workspace number $ws10

      bindsym $mod+Shift+1 move container to workspace number $ws1
      bindsym $mod+Shift+2 move container to workspace number $ws2
      bindsym $mod+Shift+3 move container to workspace number $ws3
      bindsym $mod+Shift+4 move container to workspace number $ws4
      bindsym $mod+Shift+5 move container to workspace number $ws5
      bindsym $mod+Shift+6 move container to workspace number $ws6
      bindsym $mod+Shift+7 move container to workspace number $ws7
      bindsym $mod+Shift+8 move container to workspace number $ws8
      bindsym $mod+Shift+9 move container to workspace number $ws9
      bindsym $mod+Shift+0 move container to workspace number $ws10

      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+r restart
      bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

      gaps inner 15
      gaps outer 10

      for_window [class="^.*"] border pixel 3
      for_window [window_type=dialog] resize set 1920 1080, move absolute position center

      popup_during_fullscreen ignore

      # class                 border  backgr. text    indicator child_border
      client.focused          #ffffff #285577 #ffffff #2e9ef4   #ffffff
      client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
      client.unfocused        #333333 #222222 #888888 #292d2e   #222222
      client.urgent           #2f343a #900000 #ffffff #900000   #900000
      client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c
      client.background       #ffffff

      mode "resize" {
              bindsym j resize shrink width 10 px or 10 ppt
              bindsym k resize grow height 10 px or 10 ppt
              bindsym l resize shrink height 10 px or 10 ppt
              bindsym semicolon resize grow width 10 px or 10 ppt

              bindsym Left resize shrink width 10 px or 10 ppt
              bindsym Down resize grow height 10 px or 10 ppt
              bindsym Up resize shrink height 10 px or 10 ppt
              bindsym Right resize grow width 10 px or 10 ppt

              bindsym Return mode "default"
              bindsym Escape mode "default"
              bindsym $mod+r mode "default"
      }

      bindsym $mod+r mode "resize"

      bar {
              status_command i3status
      }
    '';
  };

in
{
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "ctrl:swapcaps";

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      configFile = "${i3Config}/bin/i3Config";
      extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin = { enable = true; user = config.defaultUser.name; };
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.nordic;
            name = "Nordic";
          };
          iconTheme = {
            package = pkgs.numix-icon-theme-circle;
            name = "Numix-Circle";
          };
        };
      };
    };
  };

  console.useXkbConfig = true;

  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [ xorg.xdpyinfo ];

  environment.pathsToLink = [ "/libexec" ]; # enable polkit
  programs.dconf.enable = true;
  defaultUser.groups = [ "video" ];
}
