{ config, lib, pkgs, ... }:

lib.os.hm (_: { home.packages = with pkgs; [ zoom-us ]; })
