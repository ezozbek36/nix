{inputs, ...}: {
  disabledModules = ["services/hardware/tlp.nix"];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/hardware/tlp.nix"
    ./tlp.nix
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  services.thermald.enable = true;
}
