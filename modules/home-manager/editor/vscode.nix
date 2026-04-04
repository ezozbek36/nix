{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        skellock.just
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        wakatime.vscode-wakatime
        tamasfe.even-better-toml
        editorconfig.editorconfig
      ];
      userSettings = {
        "chat.disableAIFeatures" = true;
        "terminal.integrated.enableImages" = true;
        "terminal.integrated.gpuAcceleration" = "on";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "rust-analyzer.check.command" = "clippy";
      };
    };
  };
}
