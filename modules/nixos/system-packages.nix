{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    btop
    intel-gpu-tools
    libva-utils
    vulkan-tools
    pciutils
    usbutils
    lm_sensors
    (nvtopPackages.nvidia.override {intel = true;})
  ];
}
