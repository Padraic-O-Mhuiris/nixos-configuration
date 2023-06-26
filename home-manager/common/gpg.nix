{ config, lib, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    publicKeys = [{
      source = ../users/padraic_pub_gpg.key;
      trust = 5;
    }];
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableZshIntegration = true;
    grabKeyboardAndMouse = true;
    defaultCacheTtl = 3600;
    pinentryFlavor = "gnome3";
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
    verbose = true;
  };

  home.sessionVariables.GNUGPGHOME = "${config.xdg.dataHome}/gnupg";
}
