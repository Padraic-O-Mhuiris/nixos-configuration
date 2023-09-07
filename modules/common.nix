{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bc
    binutils
    coreutils-full
    clang
    cmake
    curl
    du-dust
    entr
    git
    file
    i7z
    iw
    libnotify
    netcat
    nix-index
    nix-tree
    openssl
    pciutils
    patchelf
    psmisc
    sd
    stdenv.cc.cc.lib
    tree
    unzip
    vim
    whois
    wget
    xclip
    zlib
  ];
} // (lib.os.hm (user: {
  programs = {
    bat.enable = true;
    btop.enable = true;
    exa.enable = true;
    feh.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    htop.enable = true;
    irssi.enable = true;
    jq.enable = true;
  };

  home.packages = with pkgs; [ qbittorrent vlc ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}))
