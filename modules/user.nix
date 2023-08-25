{ config, lib, pkgs, os, ... }:

(lib.mkMerge [
  (lib.os.applyUsers ({ name, ... }: {
    sops.secrets."user@${name}" = { neededForUsers = true; };

    users.users.${name} = {
      isNormalUser = true;
      passwordFile = config.sops.secrets."user@${name}".path;
      group = "users";
      extraGroups = [ "wheel" ];
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
