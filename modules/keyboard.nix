{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.mkIf config.services.xserver.enable {
    services.xserver = {
      xkbOptions = "ctrl:swapcaps";
      layout = "gb";
    };
  })
  { console.useXkbConfig = true; }
]
