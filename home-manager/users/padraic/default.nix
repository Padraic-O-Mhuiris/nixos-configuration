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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
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
    noti.enable = true;

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
    };

    password-store.enable = true;
    # rofi.enable = true;
    ssh.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      shortcut = "a";
      disableConfirmationPrompt = true;
      escapeTime = 0;
      secureSocket = false; # persists user logout
      keyMode = "vi";
      plugins = with pkgs; [ tmuxPlugins.better-mouse-mode ];
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = ''
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        set-option -g mouse on
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      autocd = true;
      dotDir = "${config.xdg.configHome}/zsh";
      envExtra = "";
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignorePatterns = [ ];
        ignoreSpace = true;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        save = 100000;
        share = true;
      };
      historySubstringSearch = { enable = true; };
      initExtra = "";
      initExtraBeforeCompInit = "";
      initExtraFirst = "";
      localVariables = {
        ZSH_TMUX_AUTOSTART = true;
        ZSH_TMUX_AUTOSTART_ONCE = true;
      };
      loginExtra = "";
      logoutExtra = "";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "aliases"
          "sudo"
          "direnv"
          "emoji"
          "encode64"
          "jsontools"
          "systemd"
          "dirhistory"
          "colored-man-pages"
          "command-not-found"
          "extract"
          "tmux"
        ];
      };
    };
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
      size = 8;
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
    # git-sync = {
    #   enable = true;
    #   repositories = { }; # TODO Add docs and nixos-config repo
    # };
    # kanshi = {
    #   enable = true;
    #   # TODO Add profiles
    # };
    network-manager-applet.enable = true;
    mpd.enable = true;
    # TODO Add redshift service here
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
      extraConfig = { XDG_CODE_DIR = "${config.home.homeDirectory}/code"; };
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
    };
  };

  home = {
    enableNixpkgsReleaseCheck = true;
    packages = with pkgs; [ fd ripgrep zoom-us pavucontrol spotify ];
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
