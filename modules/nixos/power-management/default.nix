{inputs,...}: {
  disabledModules = [ "modules/nixos/power-management/tlp.nix" ];

  imports = [
    "${inputs.nixpkgs-unstable}/modules/nixos/power-management/tlp.nix"
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  services.thermald.enable = true;
}
