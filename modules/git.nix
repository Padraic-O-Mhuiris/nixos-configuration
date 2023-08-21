{ config, lib, pkgs, ... }:

lib.os.applyHmUsers (user: {
  programs.git = {
    enable = true;
    userEmail = user.email;
    userName = user.github;
    signing = {
      key = user.gpg.fingerprint;
      signByDefault = true;
    };
  };
})
