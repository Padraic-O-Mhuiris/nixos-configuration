{ config, lib, pkgs, inputs, system, ... }:

(lib.os.hm
  (user: { home.packages = [ inputs.helix.packages.${pkgs.system}.default ]; }))
