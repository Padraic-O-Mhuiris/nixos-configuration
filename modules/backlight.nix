{ config, lib, pkgs, ... }:

# TODO Add keyboard buttons here
(lib.os.user
  ({ name, ... }: { users.users.${name}.extraGroups = [ "video" ]; })) // {
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight" RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  }
