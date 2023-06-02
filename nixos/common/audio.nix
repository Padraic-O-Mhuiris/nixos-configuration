{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pavucontrol ];

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  defaultUser.groups = [ "audio" ];
}
