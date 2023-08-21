{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.os.applyUsers ({ name, ... }: {
    users.users.${name}.extraGroups = [ "audio" "pipewire" ];
  }))
  {
    environment.systemPackages = with pkgs; [ pavucontrol ];

    sound.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      socketActivation = true;
      systemWide = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Must set to false as conflicts with pipewire
    hardware.pulseaudio.enable = false;
  }
]
