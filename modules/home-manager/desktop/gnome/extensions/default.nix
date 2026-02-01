{pkgs, ...}: let
  extensions = with pkgs.gnomeExtensions; [
    runcat
    appindicator
    dash-to-dock
    blur-my-shell
    window-window-title-is-back
  ];
in {
  home-manager.pkgs = extensions;

  # Export for use in dconf settings
  _module.args.gnomeExtensionsList = extensions;
}
