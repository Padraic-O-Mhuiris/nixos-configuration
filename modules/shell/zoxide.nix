{ config, lib, pkgs, ... }:

lib.os.hm (_: { programs.zoxide.enable = true; })
