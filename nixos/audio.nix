{ config, lib, pkgs, ... }:

(lib.os.applyUsers ({ name, ... }: {
  users.users.${name}.extraGroups = [ "audio" "pipewire" ];
})) // {
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

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
    '';
  };
}
