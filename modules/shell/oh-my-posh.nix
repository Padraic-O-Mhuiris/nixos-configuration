{ config, lib, pkgs, ... }:

lib.os.hm (_: {
  programs.oh-my-posh = {
    enable = true;
    useTheme = "agnoster";
  };
})
