{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
    stylix,
    nixpkgs,
    sops-nix,
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

              (import ./overlays/alacritty.nix)
            ];
          }

          ./hosts/swift-sfx14-71g/configuration.nix

          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.ezozbek = import ./modules/home-manager;
              sharedModules = [
                stylix.homeModules.stylix
              ];
            };
          }
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs-unstable.legacyPackages.${system};
      in {
        formatter = pkgs.alejandra;

        devShells.default = import ./shell.nix self {inherit pkgs;};
      }
    );
}
