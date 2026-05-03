{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

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
        # to ensure compatibility with the latest Firefox version
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts.url = "github:hercules-ci/flake-parts";

    json-schema = {
      url = "github:ezozbek36/nix-json-schema";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    relago = {
      url = "github:xinux-org/relago";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs @ {
    self,
    stylix,
    relago,
    nixpkgs,
    sops-nix,
    zen-browser,
    json-schema,
    flake-parts,
    home-manager,
    nixpkgs-unstable,
    nix-cachyos-kernel,
    mac-style-plymouth,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devShells.default = import ./shell.nix self {inherit pkgs;};
      };
      flake = {
        # NixOS configuration
        nixosConfigurations.swift-sfx14-71g = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ({...}: {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                (import ./overlays/alacritty.nix)
                nix-cachyos-kernel.overlays.pinned
                mac-style-plymouth.overlays.default
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                  };
                })
              ];
            })

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
                  zen-browser.homeModules.beta
                  json-schema.homeModules.default
                ];
              };
            }

            relago.nixosModules.default
            {
              services.relago.enable = true;
            }
          ];
        };
      };
    };
}
