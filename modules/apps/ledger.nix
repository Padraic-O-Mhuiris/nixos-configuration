{ config, lib, pkgs, ... }:

lib.os.hm (_: { home.packages = with pkgs; [ ledger-live-desktop ]; }) // {
  hardware.ledger.enable = true;
}
