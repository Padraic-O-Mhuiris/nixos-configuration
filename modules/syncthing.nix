{ config, lib, pkgs, os, ... }:

# https://nitinpassa.com/running-syncthing-as-a-system-user-on-nixos/

# syncthing is annoying and not very repeatable - does try to do some weird merging of configuration
# if mutated. Delete
{
  sops.secrets.syncthing_cert = { };
  sops.secrets.syncthing_key = { };

  environment.systemPackages = with pkgs; [ syncthing ];

  # TODO Better abstract this
  services.syncthing = {
    enable = true;
    user = "padraic";
    group = "users";
    dataDir = "/home/padraic/";
    configDir = "/home/padraic/.config/syncthing";
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
          versioning = null;
        };
      };
      devices = {
        Hydrogen = {
          id =
            "3FQY6G3-V7ECTA2-SK2CZVT-YNTOB3V-PSXVELS-CU52PLI-HLLODIG-FZCXHQH";
          addresses = [ "tcp://192.168.0.184" "tcp://100.124.13.147" ];
          autoAcceptFolders = true;
        };
        Oxygen = {
          id =
            "DJUIYGN-RDDETOR-BHEGLE3-CPXVPB5-ICKTER2-G5ZN7BZ-MPS4RL2-JC7T5AJ";
          addresses = [ "tcp://192.168.0.214" "tcp://100.83.242.156" ];
          autoAcceptFolders = true;
        };
      };
    };
  };
}
