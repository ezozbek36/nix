_: {
  nix.settings = {
    trusted-users = ["root" "ezozbek"];

    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;
}
