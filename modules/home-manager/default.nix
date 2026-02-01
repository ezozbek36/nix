# Home Manager configuration
{...}: {
  home.username = "ezozbek";
  home.homeDirectory = "/home/ezozbek";

  imports = [
    ./shell
    ./terminal
    ./programs
    ./desktop
    ./editor
    ./services
    ./fonts
  ];

  # Home Manager Version
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
