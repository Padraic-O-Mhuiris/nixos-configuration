{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-amd

    ./disko.nix

    os.modules.audio
    os.modules.bluetooth
    os.modules.boot.systemd
    os.modules.browsers.firefox
    os.modules.common
    os.modules.display.dm.lightdm
    os.modules.display.wm.i3
    os.modules.display.theme
    os.modules.documentation
    os.modules.editors.emacs
    os.modules.filesystem
    os.modules.git
    os.modules.gpu.nvidia
    os.modules.gnupg
    os.modules.kernel
    os.modules.keyboard
    os.modules.location
    os.modules.nix
    os.modules.networking
    os.modules.shell.zsh
    os.modules.sops
    os.modules.ssh
    os.modules.sudo
    os.modules.terminal
    os.modules.user
    os.modules.virtualisation.docker
    os.modules.virtualisation.qemu
    os.modules.yubikey
  ];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:9:0:0";
      amdgpuBusId = "PCI:0:2:0";
    };
    forceFullCompositionPipeline = true;
  };

  services.autorandr.profiles.main = {
    fingerprint = {
      "DP-0" =
        "00ffffffffffff004c2d9c0f000000002b1c0104b57722783ba2a1ad4f46a7240e5054bfef80714f810081c08180a9c0b3009500d1c074d600a0f038404030203a00a9504100001a000000fd003078bebe61010a202020202020000000fc00433439524739780a2020202020000000ff004831414b3530303030300a202002ce02032cf046105a405b3f5c2309070783010000e305c0006d1a0000020f307800048b127317e60605018b7312565e00a0a0a0295030203500a9504100001a584d00b8a1381440f82c4500a9504100001e1a6800a0f0381f4030203a00a9504100001af4b000a0f038354030203a00a9504100001a0000000000000000000000af701279000003013c57790188ff139f002f801f009f055400020009006c370108ff139f002f801f009f0545000200090033b70008ff139f002f801f009f0528000200090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f390";
      "HDMI-0" =
        "00ffffffffffff0010acf7404c333735091c0103803c2278ea4815a756529c270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c450056502100001e000000ff0034503948433832513537334c0a000000fc0044454c4c205032373137480a20000000fd00384c1e5311000a20202020202001bd020317b14c9005040302071601141f121365030c001000023a801871382d40582c450056502100001e011d8018711c1620582c250056502100009e011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e9600565021000018000000000000000000000000000000000000000000000000000000000000000081";
    };
    config = {
      "HDMI-0" = {
        enable = true;
        primary = false;
        position = "5120x0";
        mode = "1920x1080";
        rate = "60.00";
        rotate = "left";
      };
      "DP-0" = {
        enable = true;
        dpi = null;
        primary = true;
        position = "0x240";
        mode = "5120x1440";
        rate = "59.98";
      };
    };
  };

  # TODO Maybe lift this to os config??
  services.xserver.displayManager.autoLogin.user = "padraic";

  networking.hostId = "83b0a257";
}
