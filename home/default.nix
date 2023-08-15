{ self, config, ... }:

{
  flake = { homeModules = { common = import ./common.nix; }; };
}
