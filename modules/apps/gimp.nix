{ config, lib, pkgs, ... }:

lib.os.hm (_: { home.packages = with pkgs; [ gimp-with-plugins ]; })
