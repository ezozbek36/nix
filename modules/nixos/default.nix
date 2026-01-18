{...}: {
  imports = [
    ./nix-settings.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./audio.nix
    ./bluetooth.nix
    ./power-management.nix
    ./hardware-services.nix
    ./users.nix
    ./system-packages.nix
    ./desktop/default.nix
    ./graphics/default.nix
  ];
}
