{ config, lib, pkgs, os, ... }:

(lib.mkMerge [
  (lib.os.user ({ name, ... }: {
    # sops.secrets."user@${name}" = { neededForUsers = true; };
    users.users.${name} = {
      isNormalUser = true;
      # passwordFile = config.sops.secrets."user@${name}".path;
      # TODO Figure out why sops is not working for this on first installation?
      hashedPassword =
        "$6$7RhoYiLu0Xn50HZD$pOIypZUz6aALwRt4SlsckKmTFo0r6fHh5zbSTLBQGkrPuoJS.7bJirx936XensJSlkn0e472nKjzE7Y4tv7td0";
      group = "users";
      extraGroups = [ "wheel" "input" ];
    };

  }))
  {
    users = {
      mutableUsers = false;
      enforceIdUniqueness = true;
      users.root.hashedPassword = "!"; # Disables login for the root user
    };
  }
])
