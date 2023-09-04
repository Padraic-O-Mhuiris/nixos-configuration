{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    # inputs.hardware.nixosModules.common-hidpi
    # inputs.hardware.nixosModules.dell-xps-15-9520
    inputs.hardware.nixosModules.dell-xps-15-9520-nvidia

    ./disko.nix

    os.modules.apps.spotify
    os.modules.apps.libreoffice
    os.modules.audio
    os.modules.bluetooth
    os.modules.backlight
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
    # os.modules.gpu.nvidia
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

  # hardware.nvidia = {
  #   prime = {
  #     sync.enable = true;
  #     nvidiaBusId = "PCI:1:0:0";
  #     intelBusId = "PCI:0:2:0";
  #   };
  #   forceFullCompositionPipeline = true;
  # };

  environment.persistence."/persist".files = [ "/etc/machine-id" ];

  # NOTE Screen name ID changes between using nvidia prime or offload
  services.autorandr.profiles.main = {
    fingerprint = {
      "eDP-1" =
        "00ffffffffffff004d101615000000000a1f0104b52215780ac420af5031bd240b50540000000101010101010101010101010101010172e700a0f06045903020360050d21000001828b900a0f06045903020360050d210000018000000fe004a4e4a5939804c513135365231000000000002410332011200000b010a2020013a02030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
    };
    config = {
      "eDP-1" = {
        enable = true;
        dpi = 160;
        primary = true;
        position = "0x0";
        mode = "3840x2400";
        rate = "59.99";
      };
    };
  };

  # TODO Maybe lift this to os config??
  services.xserver.displayManager.autoLogin.user = "padraic";

  networking.hostId = "3f90d23a";
} // lib.os.applyHmUsers (_: {
  home.sessionVariables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };
})
