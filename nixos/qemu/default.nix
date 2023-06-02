{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    # import your own NixOS modules here if needed
  ];

  services.qemuGuest.enable = true;

  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0 boot.shell_on_fail" ];
    loader.timeout = 5;
  };

  virtualisation = {
    diskSize = 8000; # MB
    memorySize = 2048; # MB
    writableStoreUseTmpfs = false;
  };

}
