{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ inputs.hyprland.homeManagerModules.default ./common ];

  home = {
    username = "padraic";
    homeDirectory = "/home/padraic";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  programs.kitty.enable = true;
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
