{ config, lib, pkgs, ... }:

lib.os.applyHmUsers (user: { services.blueman-applet.enable = true; }) // {
  hardware.bluetooth = {
    enable = true;
    settings = { General.Enable = "Source,Sink,Media,Socket"; };
  };
  services.blueman.enable = true;
}
