{config, ...}: {
  hardware.nvidia = {
    modesetting.enable = true;

    # Critical for battery: turns off dGPU when not in use
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    open = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      sync.enable = false;
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}
