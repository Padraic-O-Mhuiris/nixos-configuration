{ lib, pkgs, ... }@nixosModuleArgs:

(lib.os.hm (user:
  { config, nixosConfig, ... }:
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
  in {
    xsession.windowManager.i3.config.bars = let
      colors = (config.lib.stylix.i3.bar.colors // {
        background = lib.os.colors.black;
      });
      fonts = {
        names = [ config.stylix.fonts.monospace.name ];
        size = config.stylix.fonts.sizes.desktop + 0.0;
      };
    in [
      {
        inherit fonts colors;
        mode = "dock";
        hiddenState = "hide";
        position = "top";
        workspaceButtons = false;
        workspaceNumbers = false;
        statusCommand = "${
            lib.getExe config.programs.i3status-rust.package
          } ${config.xdg.configHome}/i3status-rust/config-top.toml";
        extraConfig = ''
          output ${
            (lib.os.primaryMonitor
              nixosConfig.services.autorandr.profiles.main.config)
          }
        '';
      }
      {
        inherit fonts colors;
        mode = "dock";
        hiddenState = "hide";
        position = "bottom";
        workspaceButtons = true;
        workspaceNumbers = true;
        trayOutput = "primary";
        statusCommand = "${
            lib.getExe config.programs.i3status-rust.package
          } ${config.xdg.configHome}/i3status-rust/config-bottom.toml";
        extraConfig = ''
          output ${
            (lib.os.primaryMonitor
              nixosConfig.services.autorandr.profiles.main.config)
          }
        '';
      }
    ];

    xsession.windowManager.i3.extraConfig = ''
      bindsym ${modifier}+b bar mode toggle
    '';

    programs.i3status-rust = let
      inherit (blocks) sound backlight time disks battery cpu music location;

      i3status-rust-theme-overrides = {
        idle_bg = lib.os.colors.charcoal;
        idle_fg = lib.os.colors.silver;
        info_bg = lib.os.colors.charcoal;
        info_fg = lib.os.colors.pearl;
        good_bg = lib.os.colors.charcoal;
        good_fg = lib.os.colors.green;
        warning_bg = lib.os.colors.yellow;
        warning_fg = lib.os.colors.slate;
        critical_bg = lib.os.colors.red;
        critical_fg = lib.os.colors.black;
        separator = "|";
        separator_bg = lib.os.colors.black;
        separator_fg = lib.os.colors.pearl;
      };

    in {
      enable = true;
      bars.top = {
        icons = "awesome6";
        settings.theme.overrides = i3status-rust-theme-overrides;
        blocks = [ location disks.root disks.nix disks.home battery cpu ];
      };

      bars.bottom = {
        icons = "awesome6";
        settings.theme.overrides = i3status-rust-theme-overrides;
        blocks = [ music backlight sound time ];
      };
    };
  }))
