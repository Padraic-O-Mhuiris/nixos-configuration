{ config, lib, pkgs, ... }:

lib.os.hm (user: { services.blueman-applet.enable = true; }) // {
  hardware.bluetooth = {
    enable = true;
    settings = { General.Enable = "Source,Sink,Media,Socket"; };
  };
  services.blueman.enable = true;

  environment.persistence."/persist".directories = [ "/var/lib/bluetooth" ];
}
