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

  environment.systemPackages = with pkgs; [ syncthing ];

  # TODO Better abstract this
  services.syncthing = {
    enable = true;
    user = "padraic";
    dataDir = "/home/padraic/";
    configDir = "/home/padraic/.config/syncthing/config";
    overrideDevices = true;
    overrideFolders = true;
    cert = config.sops.secrets.syncthing_cert.path;
    key = config.sops.secrets.syncthing_key.path;
    extraFlags = [ "--no-default-folder" ];
    settings = {
      folders = {
        "notes" = {
          id = "notes";
          label = "Notes";
          path = "~/notes";
          devices = [ "Oxygen" "Hydrogen" ];
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
      };
      devices = {
        Hydrogen = {
          id =
            "IH3TXQ3-NWZQ5OZ-XOXAKOR-KGIXOI2-3QFIIO2-N2VB4SG-B3RNTMD-ZTEHIQ2";
          addresses = [ "http://192.168.0.184" ];
          autoAcceptFolders = true;
        };
        Oxygen = {
          id =
            "HWIPWZN-WPAM3PC-CGI6HMR-DNR3AVX-QX5GTHO-QS6TFGW-QPD22WN-6QR5TQC";
          addresses = [ "http://192.168.0.214" ];
          autoAcceptFolders = true;
        };
      };
    };

  };

}
