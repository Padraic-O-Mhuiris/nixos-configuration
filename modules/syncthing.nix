{ config, lib, pkgs, ... }:

{

  sops.secrets.syncthing_cert = {
    restartUnits = [ "syncthing.service" ];
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };
  sops.secrets.syncthing_key = {
    restartUnits = [ "syncthing.service" ];
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

  # TODO Better abstract this
  services.syncthing = {
    enable = true;
    user = "padraic";
    dataDir = "/home/padraic/notes";
    configDir = "/home/padraic/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    cert = config.sops.secrets.syncthing_cert.path;
    key = config.sops.secrets.syncthing_key.path;
    extraFlags = [ "--no-default-folder" ];
  };

}
