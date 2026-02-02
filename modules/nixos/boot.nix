{pkgs, ...}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "intel_pstate=active"
      "i915.enable_guc=3"
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
    ];

    kernel.sysctl = {
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.swappiness" = 10;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
