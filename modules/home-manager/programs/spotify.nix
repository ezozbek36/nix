{pkgs, ...}: {
  home.packages = [
    (pkgs.symlinkJoin
      {
        name = "spotify";
        paths = [pkgs.unstable.spotify];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/spotify \
            --add-flags "--enable-features=UseOzonePlatform --ozone-platform=x11"
        '';
      })
  ];
}
