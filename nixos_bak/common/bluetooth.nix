{ config, lib, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    settings = { General.Enable = "Source,Sink,Media,Socket"; };
  };
  services.blueman.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "\n      load-module module-switch-on-connect\n    ";
  };
}
