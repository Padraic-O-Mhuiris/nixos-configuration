{ lib, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
} // (lib.os.hm (_:
  ({ config, ... }: {
    programs = {
      direnv.enableZshIntegration = true;
      starship.enableZshIntegration = true;
      zoxide.enableZshIntegration = true;
      oh-my-posh.enableZshIntegration = true;

      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        enableVteIntegration = true;
        autocd = true;
        # dotDir = "${config.xdg.configHome}/zsh"; # TODO Figure out why this is not working
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
        # initExtra = ''
        #   session_name="MAIN"

        #   tmux has-session -t=$session_name 2> /dev/null

        #   if [[ $? -ne 0 ]]; then
        #     unset TMUX
        #     tmux new-session -d -s "$session_name"
        #   fi

        #   if [[ -z "$TMUX" ]]; then
        #     tmux attach -t "$session_name"
        #   else
        #     tmux switch-client -t "$session_name"
        #   fi
        # '';
        # profileExtra = ''
        #   tmux new-session -A -s main
        # '';
        plugins = [{
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }];
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
  })))
