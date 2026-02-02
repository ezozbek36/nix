_: {
  programs.zsh = {
    enable = true;
    #enableLsColors = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "sudo nixos-rebuild switch --flake github:ezozbek36/nix#swift-sfx14-71g";
    };

    initContent = ''

    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "thefuck"];
    };
  };
}
