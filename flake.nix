{
  description = "NixOS configuration with Home Manager";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org" "https://cuda-maintainers.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="];
  };

  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    nixpkgs-unstable,
    nix-cachyos-kernel,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in
    {
      # NixOS configuration
      nixosConfigurations.swift-sfx14-71g = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          {
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned

              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit system;
                };
              })
            ];
          }

          ./hosts/swift-sfx14-71g/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.ezozbek = import ./modules/home-manager;
            };
          }
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in {
      formatter = pkgs.alejandra;

      devShells.default = import ./shell.nix self {inherit pkgs;};
    });
}
