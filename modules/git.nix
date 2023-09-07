{ config, lib, pkgs, ... }:

lib.os.hm (user: {
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
