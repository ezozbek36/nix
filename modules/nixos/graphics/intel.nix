{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      libvdpau-va-gl
      intel-compute-runtime
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };
}
