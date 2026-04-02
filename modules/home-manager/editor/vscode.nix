{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    #defaultEditor = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        wakatime.vscode-wakatime
        editorconfig.editorconfig
        jnoortheen.nix-ide
      ];
    };
  };
}
