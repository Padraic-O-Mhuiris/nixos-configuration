{ inputs, outputs, lib, defaultUser, config, pkgs, ... }:

{
  imports = [ ../../common ];

  home = {
    username = defaultUser.name;
    homeDirectory = "/home/${defaultUser.name}";
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
    htop.enable = true;
    exa.enable = true;
    feh.enable = true;
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = defaultUser.email;
      userName = defaultUser.githubUser;
      signing = {
        key = defaultUser.gpgKey;
        signByDefault = true;
      };
    };
    helix.enable = true;
    irssi.enable = true;
    jq.enable = true;
    man.enable = true;

    neovim = {
      enable = true;
      defaultEditor = false;
      viAlias = true;
      vimAlias = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
        PASSWORD_STORE_KEY = defaultUser.gpgKey;
      };
    };
    ssh.enable = true;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 16;
    };
    font = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
      size = 10;
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  # };

  services = {
    batsignal.enable = true;
    blueman-applet.enable = true;
    clipman.enable = true;
    flameshot.enable = true;
    network-manager-applet.enable = true;
    mpd.enable = true;
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };

  targets.genericLinux.enable = true;

  xdg = {
    enable = true;
    mime.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      extraConfig = {
        XDG_CODE_DIR = "${config.home.homeDirectory}/code";
        XDG_NOTE_DIR = "${config.home.homeDirectory}/documents/notes";
      };
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
    };
  };

  home = {
    enableNixpkgsReleaseCheck = true;
    packages = with pkgs; [ fd ripgrep zoom-us pavucontrol spotify discord ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
