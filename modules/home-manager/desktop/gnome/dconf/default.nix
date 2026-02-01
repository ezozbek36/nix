{...}: {
  dconf.enable = true;

  imports = [
    ./interface.nix
    ./wm.nix
    ./touchpad.nix
    ./shell.nix
    ./dash-to-dock.nix
    ./blur-my-shell.nix
  ];
}
