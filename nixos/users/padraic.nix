{ config, lib, pkgs, ... }:

{
  sops.secrets."user@padraic" = { neededForUsers = true; };

  users.users.padraic = {
    extraGroups = [ "wheel" ];
    home = "/home/padraic";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7"
    ];
    passwordFile = config.sops.secrets."user@padraic".path;
    shell = pkgs.zsh;
    uid = 1000;
  };
}
