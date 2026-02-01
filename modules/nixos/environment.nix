{pkgs, ...}: {
  environment = {
    shells = with pkgs; [zsh];
    variables = {
      GSK_RENDERER = "ngl";
    };
  };
}
