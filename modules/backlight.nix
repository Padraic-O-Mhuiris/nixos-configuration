{ config, lib, pkgs, ... }:

# TODO Add keyboard buttons here
(lib.os.applyUsers
  ({ name, ... }: { users.users.${name}.extraGroups = [ "video" ]; })) // {
    # Necessary for backlight
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight" RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  }
