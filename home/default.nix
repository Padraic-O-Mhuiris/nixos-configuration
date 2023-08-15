{ self, config, ... }:

{
  flake = {
    homeModules = {
      common = import ./common.nix;
      other = import ./other.nix;
    };
  };
}
