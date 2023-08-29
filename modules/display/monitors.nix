{ config, lib, pkgs, ... }:

{
  services.autorandr.enable = true;
  services.autorandr.defaultTarget = "main";
}
