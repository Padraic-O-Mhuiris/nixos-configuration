{ flake, config, lib, pkgs, inputs, ... }:

lib.os.applyHmUsers (user: { programs.nix-index.enable = true; }) // {

  imports = [
    inputs.srvos.nixosModules.mixins-trusted-nix-caches
    inputs.nix-ld.nixosModules.nix-ld
  ];

  programs.nix-ld.dev.enable = true;

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      max-jobs = "auto";
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
