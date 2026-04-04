{
  stdenv,
  libgda6,
  fetchzip,
}: let
  uuid = "copyous@boerdereinar.dev";
in
  stdenv.mkDerivation (
    finalAttrs: {
      pname = "gnome-shell-extension-copyous";
      version = "2.0.0";

      src = fetchzip {
        url = "https://github.com/boerdereinar/copyous/releases/download/v${finalAttrs.version}/copyous@boerdereinar.dev.zip";
        sha256 = "AhbB85GlV2LDcbVgs36d8KlChJMP011S2Q0bM3P6v3s=";
        stripRoot = false;
      };

      buildInputs = [libgda6];

      passthru = {
        extensionUuid = uuid;
        extensionPortalSlug = "copyous";
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/gnome-shell/extensions
        cp -r -T . $out/share/gnome-shell/extensions/${uuid}
        runHook postInstall
      '';
    }
  )
