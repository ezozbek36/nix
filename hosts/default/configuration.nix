{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware.nix];

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

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "swift";
  networking.networkmanager.enable = true;

  # ── Localization ──────────────────────────────────────────────────────────
  time.timeZone = "Asia/Tashkent";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Desktop Environment: GNOME on Wayland ─────────────────────────────────
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland =  true;
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

  # Enable zsh system-wide (required for user shell)
  programs.zsh.enable = true;

  # ── System Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];

  # ── System Version ────────────────────────────────────────────────────────
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.11";
}
