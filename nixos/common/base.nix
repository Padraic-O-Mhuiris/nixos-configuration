{ config, lib, pkgs, ... }:

{
  # TODO Discern what should go here
  environment.systemPackages = with pkgs; [
    bc
    binutils
    coreutils
    clang
    cmake
    dmidecode
    curl
    entr
    exa
    git
    file
    i7z
    iw
    jq
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
    xorg.xdpyinfo
    zlib
  ];

  services.ntp.enable = true;
}
