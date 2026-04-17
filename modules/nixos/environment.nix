{pkgs, ...}: {
  environment = {
    shells = with pkgs; [zsh];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
