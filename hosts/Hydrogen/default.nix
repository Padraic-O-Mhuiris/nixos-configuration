{ os, lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.dell-xps-15-9520-nvidia
    inputs.impermanence.nixosModules.impermanence

    ./disko.nix
    ./monitors.nix

    os.modules.apps.spotify
    os.modules.apps.discord
    os.modules.apps.libreoffice
    os.modules.apps.matrix
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
    os.modules.syncthing
    os.modules.tailscale
    os.modules.terminal.alacritty
    os.modules.user
    os.modules.virtualisation.docker
    os.modules.virtualisation.qemu
    os.modules.yubikey
  ];

  environment.persistence."/persist".files = [ "/etc/machine-id" ];
  # TODO Maybe lift this to os config??
  services.xserver.displayManager.autoLogin.user = "padraic";

  networking.hostId = "3f90d23a";

  stylix.fonts.sizes = {
    applications = 11;
    desktop = 10;
    popups = 22;
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
