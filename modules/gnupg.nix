{ lib, pkgs, ... }:

lib.os.applyHmUsers (user:
  ({ config, ... }: {
    programs.gpg = {
      enable = true;
      mutableKeys = false;
      publicKeys = [{
        text = user.gpg.key;
        trust = 5;
      }];
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableScDaemon = true;
      grabKeyboardAndMouse = true;
      defaultCacheTtl = 3600;
      pinentryFlavor = "gnome3";
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      verbose = true;
    };

    systemd.user.sessionVariables.GNUPGHOME = "${config.xdg.dataHome}/gnupg";

    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
        PASSWORD_STORE_KEY = user.gpg.fingerprint;
      };
    };
  }))
