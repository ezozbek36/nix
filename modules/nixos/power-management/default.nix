{...}: {
  imports = [
    ./tlp
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  services.thermald.enable = true;
}
