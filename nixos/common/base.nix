{ config, lib, pkgs, ... }:

{
  # TODO Discern what should go here
  environment.systemPackages = with pkgs; [
    bc
    binutils
    coreutils
    clang
    cmake
    curl
    dmidecode
    entr
    exa
    git
    file
    i7z
    iw
    jq
    netcat
    nix-index
    nix-tree
    openssl
    pciutils
    patchelf
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
