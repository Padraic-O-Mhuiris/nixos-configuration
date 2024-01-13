{ lib, ... }:

(lib.os.hm (user:
  ({ config, pkgs, ... }: {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/desktop";
        download = "${config.home.homeDirectory}/downloads";
        documents = "${config.home.homeDirectory}/documents";
        extraConfig = { XDG_CODE_DIR = "${config.home.homeDirectory}/code"; };
        music = "${config.home.homeDirectory}/music";
        pictures = "${config.home.homeDirectory}/pictures";
        publicShare = "${config.home.homeDirectory}/public";
        templates = "${config.home.homeDirectory}/templates";
        videos = "${config.home.homeDirectory}/videos";
      };
    };

    home.packages = with pkgs; [ gnome.nautilus ];
  }))) // {
    services.udisks2.enable = true;
    programs.gnome-disks.enable = true;
  }
