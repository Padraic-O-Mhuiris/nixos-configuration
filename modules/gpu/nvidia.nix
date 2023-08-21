{ inputs, config, lib, pkgs, ... }:

{
  imports = [ inputs.hardware.nixosModules.common-gpu-nvidia ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
