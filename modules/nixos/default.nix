{...}: {
  imports = [
    ./nix-settings
    ./boot
    ./networking
    ./locale
    ./audio
    ./bluetooth
    ./power-management
    ./hardware-services
    ./users
    ./system-packages
    ./desktop
    ./graphics
    ./environment
  ];
}
