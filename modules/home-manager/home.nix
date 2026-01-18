# Home Manager configuration
{inputs, ...}: {
  home.username = "ezozbek";
  home.homeDirectory = "/home/ezozbek";

  imports = [
    inputs.zen-browser.homeModules.beta
    ./shell/zsh.nix
    ./shell/starship.nix
    ./terminal/alacritty.nix
    ./programs/git.nix
    ./programs/browser.nix
    ./fonts.nix
    ./desktop/gnome.nix
  ];

  # ── Home Manager Version ──────────────────────────────────────────────────
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
