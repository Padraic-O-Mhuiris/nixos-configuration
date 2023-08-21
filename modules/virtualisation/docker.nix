{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.os.applyUsers
    ({ name, ... }: { users.users.${name} = { extraGroups = [ "docker" ]; }; }))

  { virtualisation.docker.enable = true; }
]
