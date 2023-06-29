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
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
extraConfig = "
  load-module module-switch-on-connect
";
  };
  defaultUser.groups = [ "audio" ];
}
