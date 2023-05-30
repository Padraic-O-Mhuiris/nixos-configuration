{ config, lib, pkgs, ... }:

{
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.enforceIdUniqueness = true;
  users.users.root.hashedPassword = null;
}
