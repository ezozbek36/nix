final: prev: {
  alacritty = prev.alacritty.overrideAttrs (oldAttrs: {
    env =
      (oldAttrs.env or {})
      // {
        RUSTFLAGS = "-C target-cpu=x86-64-v3 -C lto=fat -C codegen-units=1";
      };
  });
}
