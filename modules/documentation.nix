{ config, lib, pkgs, ... }:

lib.os.applyHmUser (user: {
  programs.man.enable = true;

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}) // {
  documentation.enable = lib.mkDefault false;
  documentation.info.enable = lib.mkDefault false;
  documentation.man.enable = lib.mkDefault false;
  documentation.nixos.enable = lib.mkDefault false;
}
