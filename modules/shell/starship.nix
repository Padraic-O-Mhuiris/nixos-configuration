{ config, lib, pkgs, ... }:

lib.os.hm (_: { programs.starship.enable = true; })
