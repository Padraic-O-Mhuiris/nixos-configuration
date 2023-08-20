{ config, lib, pkgs, ... }:

(if config.services.xserver.enable then {
  services.xserver = {
    xkbOptions = "ctrl:swapcaps";
    layout = "gb";
  };
} else
  { }) // {
    console.useXkbConfig = true;
  }
