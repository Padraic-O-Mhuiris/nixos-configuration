{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.mkIf config.services.xserver.enable {
    services.xserver = {
      xkbOptions = "ctrl:swapcaps";
      layout = if config.networking.hostName == "Oxygen" then "us" else "gb";
    };
  })
  { console.useXkbConfig = true; }
]
