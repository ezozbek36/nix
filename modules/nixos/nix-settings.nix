_: {
  nix.settings = {
    trusted-users = ["root" "ezozbek"];

    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;

    substituters = ["https://attic.xuyh0120.win/lantian"];
    trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
  };

  nixpkgs.config.allowUnfree = true;
}
