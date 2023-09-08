{ lib, pkgs, ... }:

lib.os.hm (_: {
  tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    shortcut = "a";
    disableConfirmationPrompt = true;
    escapeTime = 0;
    secureSocket = false;
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

  stylix.targets.tmux.enable = true;
})
