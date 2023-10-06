{ config, lib, pkgs, os, ... }:

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
    devices = {
      Hydrogen = {
        id = "IH3TXQ3-NWZQ5OZ-XOXAKOR-KGIXOI2-3QFIIO2-N2VB4SG-B3RNTMD-ZTEHIQ2";
        addresses = [ os.configuration.Hydrogen.ip.local ];
      };
      Oxygen = {
        id = "HWIPWZN-WPAM3PC-CGI6HMR-DNR3AVX-QX5GTHO-QS6TFGW-QPD22WN-6QR5TQC";
        addresses = [ os.configuration.Oxygen.ip.local ];
      };
    };
  };

}
