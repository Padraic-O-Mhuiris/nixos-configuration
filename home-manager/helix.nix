{ config, lib, pkgs, ... }:

let
  code = pkgs.writeShellScriptBin "code" ''
    cd $(${pkgs.zoxide}/bin/zoxide query $1);
    tmux new-window
    tmux splitw -h
    tmux splitw -h
    tmux select-layout even-horizontal

    tmux selectp -t 1
    tmux resize-pane -L 30
    tmux selectp -t 2
    tmux resize-pane -R 30

    tmux send-keys -t 1 C-z "${pkgs.lazygit}/bin/lazygit" Enter
    tmux send-keys -t 2 C-z "${pkgs.helix}/bin/hx ." Enter
  '';
in
{
  programs.helix = {
    enable = true;
    # defaultEditor = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        file-types = [ "nix" ];
        roots = [ "flake.nix" "flake.lock" ".envrc" ];
        comment-token = "#";
        language-server = { command = "${pkgs.nil}/bin/nil"; };
        formatter = { command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"; };
      }
      {
        name = "beancount";
        auto-format = true;
        file-types = [ "beancount" ];
        roots = [ "flake.nix" "flake.lock" ".envrc" ];
        comment-token = ";;";
        language-server = { command = "${pkgs.beancount-language-server}/bin/beancount-language-server"; args = [ "--stdio" ]; };
        formatter = { command = "${pkgs.beancount}/bin/bean-format"; };
        config = { journal_file = "./main.beancount"; };
      }
    ];
  };

  home.packages = with pkgs; [
    code
    lazygit
    # nix
    nil
    # rust
    rust-analyzer
    lldb_9
  ];
}
