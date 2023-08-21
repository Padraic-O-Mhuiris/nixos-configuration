{ config, lib, pkgs, ... }:

{
  security.sudo = {
    execWheelOnly = true;
    extraRules = [{
      users = lib.os.mapUsers ({ name, ... }: name);
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
