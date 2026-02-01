{pkgs, ...}: {
  services.displayManager.gdm.enable = true;

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling', 'autoclose-xwayland']
    '';
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    epiphany
    gnome-tour
    gnome-music
    totem
  ];
}
