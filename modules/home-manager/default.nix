# Home Manager configuration
{inputs, ...}: {
  home.username = "ezozbek";
  home.homeDirectory = "/home/ezozbek";

  imports = [
    inputs.zen-browser.homeModules.beta
    ./shell
    ./terminal
    ./programs
    ./desktop
    ./fonts.nix
  ];

  # ── Home Manager Version ──────────────────────────────────────────────────
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
