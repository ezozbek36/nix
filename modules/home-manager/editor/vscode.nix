{pkgs,...}: {
  programs.vscode = {
    enable = true;
    defaultEditor = true;
    extensions = with pkgs.vscode-extensions; [
      wakatime.vscode-wakatime
      editorconfig.editorconfig
    ];
  };
}