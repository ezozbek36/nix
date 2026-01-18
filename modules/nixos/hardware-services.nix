{...}: {
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  services.libinput.enable = true;
}
