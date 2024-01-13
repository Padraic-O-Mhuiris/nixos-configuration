{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-cpu-amd

    inputs.impermanence.nixosModules.impermanence

    ./disko.nix
    ./monitors.nix

    os.modules.apps.spotify
    os.modules.apps.slack
    os.modules.apps.discord
    os.modules.apps.ledger
    os.modules.apps.libreoffice
    os.modules.apps.matrix
    os.modules.apps.gimp
    os.modules.apps.steam
    os.modules.apps.telegram
    os.modules.apps.zoom
    os.modules.audio
    os.modules.bluetooth
    os.modules.backlight
    os.modules.boot.systemd
    os.modules.browsers.firefox
    os.modules.common
    # os.modules.display.bars.polybar
    os.modules.display.bars.i3status
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
    os.modules.gpu.nvidia
    os.modules.networking
    os.modules.shell.aliases
    os.modules.shell.direnv
    os.modules.shell.oh-my-posh
    os.modules.shell.starship
    os.modules.shell.tmux
    os.modules.shell.zoxide
    os.modules.shell.zsh
    os.modules.sops
    os.modules.ssh
    os.modules.sudo
    os.modules.syncthing
    os.modules.tailscale
    os.modules.terminal.alacritty
    os.modules.user
    os.modules.virtualisation.docker
    os.modules.virtualisation.qemu
    os.modules.yubikey
  ];

  environment.persistence."/persist".files = [ "/etc/machine-id" ];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:9:0:0";
      amdgpuBusId = "PCI:0:2:0";
    };
    forceFullCompositionPipeline = true;
  };

  stylix.fonts.sizes = {
    applications = 10;
    desktop = 10;
    popups = 16;
    terminal = 11;
  };

  # TODO Maybe lift this to os config??
  services.xserver.displayManager.autoLogin.user = "padraic";

  networking.hostId = "83b0a257";

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.05";
} // lib.os.hm (_: {
  home.pointerCursor.size = 24;

  stylix.targets = { vim.enable = true; };
})
