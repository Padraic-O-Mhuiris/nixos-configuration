{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.dell-xps-15-9520-nvidia
    inputs.impermanence.nixosModules.impermanence

    ./disko.nix

    os.modules.apps.spotify
    os.modules.apps.discord
    os.modules.apps.libreoffice
    os.modules.audio
    os.modules.bluetooth
    os.modules.backlight
    os.modules.boot.systemd
    os.modules.browsers.firefox
    os.modules.common
    os.modules.display.bars.polybar
    # os.modules.display.bars.i3status
    os.modules.display.cursor
    os.modules.display.fonts
    os.modules.display.displayManagers.lightdm
    os.modules.display.launchers.rofi
    os.modules.display.notifications.dunst
    os.modules.display.redshift
    os.modules.display.theme
    os.modules.display.windowManagers.i3
    os.modules.documentation
    os.modules.editors.emacs
    os.modules.filesystem
    os.modules.git
    os.modules.gnupg
    os.modules.kernel
    os.modules.keyboard
    os.modules.location
    os.modules.nix
    os.modules.networking
    os.modules.shell.zsh
    os.modules.shell.direnv
    os.modules.shell.oh-my-posh
    os.modules.shell.starship
    os.modules.shell.tmux
    os.modules.shell.zoxide
    os.modules.sops
    os.modules.ssh
    os.modules.sudo
    os.modules.terminal.alacritty
    os.modules.user
    os.modules.virtualisation.docker
    os.modules.virtualisation.qemu
    os.modules.yubikey
  ];

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

  stylix.fonts.sizes = {
    applications = 14;
    desktop = 10;
    popups = 24;
    terminal = 18;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05";

} // lib.os.hm (_: {
  home = {
    sessionVariables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
    };
    pointerCursor.size = 36;
  };

  stylix.targets = { vim.enable = true; };
})
