{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    btop
    nvtopPackages.intel
    nvtopPackages.nvidia
    intel-gpu-tools
    libva-utils
    vulkan-tools
    pciutils
    usbutils
    lm_sensors
  ];
}
