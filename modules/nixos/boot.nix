{
  pkgs,
  config,
  ...
}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };

    kernelPackages = pkgs.linuxKernel.packagesFor pkgs.cachyosKernels.linux-cachyos-latest-lto-x86_64-v3;

    #supportedFilesystems.zfs = true;
    #zfs = {
    #  package = config.boot.kernelPackages.zfs_cachyos;
    #};

    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "intel_pstate=active"
    ];

    kernel.sysctl = {
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.page-cluster" = 0;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
