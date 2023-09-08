{ config, lib, pkgs, ... }:

lib.os.hm (_: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
    settings.global = {
      monitor = 0;
      geometry = "600x50-50+65";
      shrink = "yes";
      transparency = 10;
      padding = 16;
      horizontal_padding = 16;
      font = lib.mkDefault "${config.stylix.fonts.sansSerif.name} ${
          toString config.stylix.fonts.sizes.applications
        }";
      line_height = 4;
      format = "<b>%s</b>\\n%b";
    };
  };

  stylix.targets.dunst.enable = true;
}) // {
  environment.systemPackages = with pkgs; [ libnotify dbus ];
}
