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
            "3FQY6G3-V7ECTA2-SK2CZVT-YNTOB3V-PSXVELS-CU52PLI-HLLODIG-FZCXHQH";
          addresses = [ "http://192.168.0.184" ];
          autoAcceptFolders = true;
        };
        Oxygen = {
          id =
            "DJUIYGN-RDDETOR-BHEGLE3-CPXVPB5-ICKTER2-G5ZN7BZ-MPS4RL2-JC7T5AJ";
          addresses = [ "http://192.168.0.214" ];
          autoAcceptFolders = true;
        };
      };
    };

  };

}
