flake: {pkgs, ...}:
pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    nixd
    statix
    deadnix
    alejandra

    sops
    ssh-to-age
  ];
}
