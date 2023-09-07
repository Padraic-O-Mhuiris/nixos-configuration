{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.os.user
    ({ name, ... }: { users.users.${name} = { extraGroups = [ "docker" ]; }; }))

  { virtualisation.docker.enable = true; }
]
