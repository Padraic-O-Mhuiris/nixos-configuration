{ inputs, config, lib, pkgs, ... }:

{
  hardware = {
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # TODO Takes a long time to build?
  # environment.systemPackages = with pkgs; [ nvtop ];
}
