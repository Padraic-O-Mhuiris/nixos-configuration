{ config, lib, pkgs, ... }:

{
  imports = [ ./nix.nix ./gpg.nix ./obsidian.nix ];
}
