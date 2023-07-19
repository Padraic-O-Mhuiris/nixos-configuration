{ config, lib, pkgs, ... }:

{

  programs.helix = {
    enable = true;
    languages.language = [{
      name = "nix";
      auto-format = true;
      file-types = [ "nix" ];
      roots = [ "flake.nix" "flake.lock" ".envrc" ];
      comment-token = "#";
      language-server = { command = "${pkgs.nil}/bin/nil"; };
      formatter = { command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"; };
    }];
  };
  home.packages = with pkgs; [
    # nix
    nil
    # rust
    rust-analyzer
    lldb_9
  ];
}
