{ lib, pkgs, ... }@nixosModuleArgs:

(lib.os.applyHmUsers (user:
{ config, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;

  blocks = {
    sound = { block = "sound"; };
    backlight = {
      block = "backlight";
      device = "intel_backlight";
    };
    disks = {
      root = {
        block = "disk_space";
        path = "/";
        format = " [$icon / $used] ";
        format_alt = " [$icon / used / $total] ";
        info_type = "used";
        interval = 60;
        warning = 20.0;
        alert = 10.0;
      };
      nix = {
        block = "disk_space";
        path = "/nix";
        format = " [$icon /nix $used] ";
        format_alt = " [$icon /nix $used / $total] ";
        info_type = "used";
        interval = 60;
        warning = 20.0;
        alert = 10.0;
      };
      home = {
        block = "disk_space";
        path = "/home";
        format = " [$icon /home $used] ";
        format_alt = " [$icon /home $used / $total] ";
        info_type = "used";
        interval = 60;
        warning = 20.0;
        alert = 10.0;
      };
    };
    cpu = {
      block = "cpu";
      interval = 0.2;
      format = " $icon $barchart $utilization ";
    };
    music = {
      block = "music";
      format =
        " $icon {$combo.str(max_w:100,rot_interval:0.1) $prev $play $next |}";
    };
    location = {
      block = "external_ip";
      format =
        " $ip [$country_code $country_flag] [$longitude:$latitude] [$timezone $utc_offset] ";
    };
    time = {
      block = "time";
      interval = 60;
      format = " $timestamp.datetime(f:'%a %d/%m %R') ";
    };
    battery = {
      block = "battery";
      format = " $icon $time $percentage ";
      charging_format = " $icon $time $percentage ";
      full_format = " $icon 100% ";
      interval = 1;
      not_charging_format = " $icon $time ";
      empty_format = " $icon $time ";
      device = "BAT0";
      driver = "sysfs";
      model = "DELL M59JH25";
      missing_format = "";
    };
  };
in
{
  xsession.windowManager.i3.config.bars = [
    {
      # colors = (config.lib.stylix.i3.bar.colors // {
      #   background = colors.base00;
      # });
      fonts = {
        names =
          nixosModuleArgs.config.fonts.fontconfig.defaultFonts.monospace;
        size = 10.0; # TODO globalise
      };
      mode = "dock";
      hiddenState = "hide";
      position = "top";
      workspaceButtons = false;
      workspaceNumbers = false;
      statusCommand = "${
            lib.getExe config.programs.i3status-rust.package
          } ${config.xdg.configHome}/i3status-rust/config-top.toml";
    }
    {
      # colors =
      #   (config.lib.stylix.i3.bar.colors // { background = colors.base01; });
      fonts = {
        names =
          nixosModuleArgs.config.fonts.fontconfig.defaultFonts.monospace;
        size = 10.0; # TODO globalise
      };
      mode = "dock";
      hiddenState = "hide";
      position = "bottom";
      workspaceButtons = true;
      workspaceNumbers = true;
      trayOutput = "primary";
      statusCommand = "${
            lib.getExe config.programs.i3status-rust.package
          } ${config.xdg.configHome}/i3status-rust/config-bottom.toml";
    }
  ];

  xsession.windowManager.i3.extraConfig = ''
    bindsym ${modifier}+b bar mode toggle
  '';

  programs.i3status-rust =
    let
      inherit (blocks) sound backlight time disks battery cpu music location;

      # colors = config.lib.stylix.colors.withHashtag;

      # i3status-rust-theme-overrides = {
      #   idle_bg = colors.base00;
      #   idle_fg = colors.base06;
      #   info_bg = colors.base00;
      #   info_fg = colors.base06;
      #   good_bg = colors.base00;
      #   good_fg = colors.base0B;
      #   warning_bg = colors.base0A;
      #   warning_fg = colors.base00;
      #   critical_bg = colors.base08;
      #   critical_fg = colors.base00;
      #   separator = "|";
      #   separator_bg = colors.base00;
      #   separator_fg = colors.base06;
      # };

    in
    {
      enable = true;
      bars.top = {
        icons = "awesome6";
        # settings.theme.overrides = i3status-rust-theme-overrides;
        blocks = [ location disks.root disks.nix disks.home battery cpu ];
      };

      bars.bottom = {
        icons = "awesome6";
        # settings.theme.overrides = i3status-rust-theme-overrides;
        blocks = [ music backlight sound time ];
      };
    };
}))
