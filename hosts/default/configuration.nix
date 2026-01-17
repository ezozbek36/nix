{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  # ── Nix Settings ──────────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel parameters for i7-13700H Raptor Lake + NVIDIA
  boot.kernelParams = [
    # NVIDIA suspend/resume
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"

    # Intel Raptor Lake hybrid architecture (P-cores + E-cores)
    "intel_pstate=active" # HWP for Thread Director aware scheduling

    # Intel iGPU (Iris Xe) optimizations
    "i915.enable_guc=3" # GuC submission + HuC (required for media encoding)
    "i915.enable_fbc=1" # Framebuffer compression (power savings)
    "i915.enable_psr=1" # Panel Self Refresh (power savings on eDP)
  ];

  # Kernel sysctl tuning for i7-13700H
  boot.kernel.sysctl = {
    # VM writeback tuning for NVMe (Micron 3400)
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.swappiness" = 10; # Prefer RAM over swap

    # Network performance (BBR congestion control)
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = null; # Let intel_pstate/TLP handle this
  };

  # ── Zram Swap ─────────────────────────────────────────────────────────────
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd"; # Best compression ratio
  };

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "swift";
  networking.networkmanager.enable = true;

  # ── Localization ──────────────────────────────────────────────────────────
  time.timeZone = "Asia/Tashkent";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Desktop Environment: GNOME on Wayland ─────────────────────────────────
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable unwanted GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    epiphany
    gnome-tour
    gnome-music
    totem
  ];

  # ── Audio: PipeWire ───────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  # ── Graphics: Intel iGPU + NVIDIA dGPU (PRIME Offload) ────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API for Intel (iHD)
      libva-vdpau-driver # VDPAU via VA-API
      libvdpau-va-gl # VDPAU via OpenGL
      intel-compute-runtime # OpenCL for Intel
      vulkan-validation-layers
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # NVIDIA driver configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # Enable power management for suspend/resume
    powerManagement.finegrained = true; # Turn off GPU when not in use (RTX 30/40 series)
    open = true; # Use open-source kernel modules (recommended for RTX 40 series)
    nvidiaSettings = true; # nvidia-settings GUI
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME offload mode: render on-demand with dGPU
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides `nvidia-offload` wrapper
      };
      # Bus IDs from lspci
      intelBusId = "PCI:0:2:0"; # Intel Iris Xe @ 00:02.0
      nvidiaBusId = "PCI:1:0:0"; # RTX 4050 @ 01:00.0
    };
  };

  # Load NVIDIA driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Environment variables for Wayland + NVIDIA
  environment.sessionVariables = {
    # VA-API driver for Intel
    LIBVA_DRIVER_NAME = "iHD";
    # Prefer Wayland for Electron apps
    NIXOS_OZONE_WL = "1";
    # GBM backend for NVIDIA on Wayland
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # ── Thunderbolt 4 ─────────────────────────────────────────────────────────
  services.hardware.bolt.enable = true;

  # ── Power Management ──────────────────────────────────────────────────────
  services.thermald.enable = true; # Intel thermal management

  services.tlp = {
    enable = true;
    settings = {
      # ── CPU Scaling (i7-13700H: 6 P-cores + 8 E-cores) ──
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power"; # Better E-core utilization

      # Intel P-state (HWP) - percentages of max frequency (5GHz)
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50; # 2.5GHz max on battery

      # Intel HWP dynamic boost (Raptor Lake)
      CPU_HWP_DYN_BOOST_ON_AC = 1; # Allow boost to 5GHz
      CPU_HWP_DYN_BOOST_ON_BAT = 0; # Disable boost on battery

      # Turbo boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Platform profile (ACPI, Raptor Lake specific)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # ── PCIe Power Management ──
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # ── Intel WiFi (CNVi) ──
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # ── USB ──
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1; # Don't autosuspend Bluetooth

      # ── NVMe/SATA ──
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";
      DISK_IOSCHED = "mq-deadline"; # Good for NVMe

      # ── Audio (Intel cAVS) ──
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # ── Runtime PM (NVIDIA handled by finegrained) ──
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  # Disable power-profiles-daemon (conflicts with TLP)
  services.power-profiles-daemon.enable = false;

  # ── Firmware ──────────────────────────────────────────────────────────────
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  services.fwupd.enable = true; # Firmware updates via LVFS

  # ── Input ─────────────────────────────────────────────────────────────────
  services.libinput.enable = true;

  # ── User Account ──────────────────────────────────────────────────────────
  users.users.ezozbek = {
    isNormalUser = true;
    description = "Ezozbek";
    extraGroups = ["wheel" "networkmanager" "audio" "video"];
    hashedPassword = "$6$VS7HOH1y17OVyKwW$.999D5CA/R73BHRayD9UUR84K0Q9/IZbMsVqXdJMjLpBJEz7dpHbzUSQaN.Aem2Wb3evSUuZ7xnM.6J.Ty9m90";
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # ── System Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    wget
    curl
    # GPU/hardware tools
    nvtopPackages.nvidia # GPU monitoring
    intel-gpu-tools # Intel GPU debugging (intel_gpu_top)
    libva-utils # VA-API debugging (vainfo)
    vulkan-tools # Vulkan debugging (vulkaninfo)
    #glxinfo # OpenGL debugging
    pciutils # lspci
    usbutils # lsusb
    lm_sensors # Temperature sensors
  ];

  # ── Boot Specialisations (GPU Modes) ──────────────────────────────────────
  specialisation = {
    # iGPU-only mode: disable NVIDIA completely (maximum battery life)
    iGPU-only.configuration = {
      system.nixos.tags = ["iGPU-only"];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
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

    # PRIME Sync mode: dGPU always active (better performance, more power)
    PRIME-sync.configuration = {
      system.nixos.tags = ["PRIME-sync"];
      hardware.nvidia.prime = {
        offload.enable = lib.mkForce false;
        offload.enableOffloadCmd = lib.mkForce false;
        sync.enable = lib.mkForce true;
      };
      hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
    };
  };

  # ── System Version ────────────────────────────────────────────────────────
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.11";
}
