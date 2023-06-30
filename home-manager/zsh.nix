{ config, lib, pkgs, ... }:

{
  programs = {
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
      };
      loginExtra = "";
      logoutExtra = "";
      # oh-my-zsh = {
      #   enable = true;
      #   plugins = [
      #     "git"
      #     "aliases"
      #     "sudo"
      #     "direnv"
      #     "emoji"
      #     "encode64"
      #     "jsontools"
      #     "systemd"
      #     "dirhistory"
      #     "colored-man-pages"
      #     "command-not-found"
      #     "extract"
      #     "nix"
      #   ];
      #   customPkgs = with pkgs; [ nix-zsh-completions ];
      };
    };

  };
}
