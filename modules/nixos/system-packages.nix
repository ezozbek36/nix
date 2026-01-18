{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    nvtopPackages.nvidia
    intel-gpu-tools
    libva-utils
    vulkan-tools
    pciutils
    usbutils
    lm_sensors
  ];
}
