{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.session = [{
      name = "home-manager";
      start = ''
        ${pkgs.runtimeShell} $HOME/.hm-xsession &
        waitPID=$!
      '';
    }];
    displayManager.defaultSession = "home-manager";
  };

  environment.systemPackages = with pkgs; [ xorg.xdpyinfo xorg.xbacklight ];

  services.autorandr.enable = true;
  services.autorandr.defaultTarget = "main";

} // (lib.os.hm (_: {
  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    profileExtra = "${lib.getExe' pkgs.autorandr "autorandr"} -l main";
  };
}))
