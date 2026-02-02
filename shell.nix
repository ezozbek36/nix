{pkgs, ...}:
pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    nixd
    statix
    deadnix
    alejandra
  ];
}
