{ self, config, ... }:

{
  flake = {
    nixosModules = {
      audio = import ./audio.nix;
      bluetooth = import ./bluetooth.nix;
      ssh = import ./ssh.nix;
    };
  };
}
