{ config, lib, pkgs, inputs, ... }:

lib.os.applyHmUser (user: { programs.nix-index.enable = true; }) // {
  imports = [ inputs.srvos.nixosModules.mixins-trusted-nix-caches ];

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      connect-timeout = 5;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      log-lines = lib.mkDefault 25;
      builders-use-substitutes = true;
      max-free = lib.mkDefault (1000 * 1000 * 1000);
      min-free = lib.mkDefault (128 * 1000 * 1000);
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedClass = lib.mkDefault "idle";
    daemonIOSchedPriority = lib.mkDefault 7;
  };
}
