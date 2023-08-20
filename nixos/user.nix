{ config, lib, pkgs, ... }:

(lib.os.applyUsers ({ name, ... }: {

  sops.secrets."user@${name}" = { neededForUsers = true; };
  users.users.${name} = {
    isNormalUser = true;
    passwordFile = config.sops.secrets."user@${name}".path;
    extraGroups = [ "wheel" ];
  };
})) // {
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    enforceIdUniqueness = true;
    users.root.hashedPassword = "!"; # Disables login for the root user
  };

  programs.zsh.enable = true;

}
