{ config, lib, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    enforceIdUniqueness = true;
    users.root.hashedPassword = "!"; # Disables login for the root user
  };

  # Must be set if defaultUserShell is set to true
  programs.zsh.enable = true;
}
