{inputs, ...}: {
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ../../modules/nixos/default.nix
  ];

  # Host-specific overrides can be added here if needed
  system.stateVersion = "25.11";
}
