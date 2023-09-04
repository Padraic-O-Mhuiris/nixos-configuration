{ config, lib, pkgs, ... }:

lib.os.applyHmUsers (_: { home.packages = with pkgs; [ libreoffice ]; })
