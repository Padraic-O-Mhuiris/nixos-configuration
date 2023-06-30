{ config, lib, pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font.size = 12;
        window.padding = {
          x = 10;
          y = 10;
        };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "agnoster";
    };


    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      autocd = true;
      dotDir = ".config/zsh";
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
      localVariables = { };
      loginExtra = "";
      logoutExtra = "";
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
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
        ];
      };
    };
  };
}
