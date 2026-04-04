{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    jetbrains.rust-rover
  ];
}
