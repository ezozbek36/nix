{gnomeExtensionsList, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (ext: ext.extensionUuid) gnomeExtensionsList;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
  };
}
