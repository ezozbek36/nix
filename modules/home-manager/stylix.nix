{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../../assets/wallpapers/ye-graduation-album-cover.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

    #cursor = {
    #  package = pkgs.bibata-cursors;
    #  name = "Bibata-Modern-Ice";
    #};

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
