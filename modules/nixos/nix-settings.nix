_: {
  nix.settings = {
    trusted-users = ["root" "ezozbek"];

    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;

    substituters = ["https://nix-community.cachix.org" "https://cuda-maintainers.cachix.org" "https://attic.xuyh0120.win/lantian"];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
