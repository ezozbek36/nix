{lib, ...}: {
  specialisation = {
    iGPU-only.configuration = {
      system.nixos.tags = ["iGPU-only"];
      hardware.nvidia = {
        prime = {
          offload.enable = lib.mkForce false;
          offload.enableOffloadCmd = lib.mkForce false;
        };
        powerManagement.finegrained = lib.mkForce false;
      };
      boot.extraModprobeConfig = ''
        blacklist nouveau
        blacklist nvidia
        blacklist nvidia_drm
        blacklist nvidia_uvm
        blacklist nvidia_modeset
      '';
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_uvm"
        "nvidia_modeset"
      ];
      services.xserver.videoDrivers = lib.mkForce ["modesetting"];
    };
    PRIME-sync.configuration = {
      system.nixos.tags = ["PRIME-sync"];
      hardware.nvidia = {
        prime = {
          offload.enable = lib.mkForce false;
          offload.enableOffloadCmd = lib.mkForce false;
          sync.enable = lib.mkForce true;
        };
        powerManagement.finegrained = lib.mkForce false;
      };
    };
  };
}
