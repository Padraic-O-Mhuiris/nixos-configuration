{ config, lib, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    enforceIdUniqueness = true;
    users.root.hashedPassword = null;
  };
}
