# NixOS Configuration

Personal NixOS configuration for an Acer Swift SFX14-71G laptop with Intel + NVIDIA hybrid graphics.

## Features

### Performance-Optimized Kernel

Uses the [CachyOS kernel](https://github.com/CachyOS/linux-cachyos) with:
- LTO (Link-Time Optimization)
- x86-64-v3 architecture targeting (AVX2)
- BBR congestion control

Thanks to [xddxdd/nix-cachyos-kernel](https://github.com/xddxdd/nix-cachyos-kernel) for the Nix packaging and providing it's Caches!

### Hybrid Graphics

NVIDIA PRIME offload mode for optimal battery life:
- Intel iGPU for daily use
- NVIDIA dGPU available on-demand via `nvidia-offload`
- Fine-grained power management (GPU sleeps when idle)

### Power Management

Comprehensive TLP configuration with distinct AC/battery profiles:
- **AC**: Performance governor, turbo boost enabled
- **Battery**: Powersave governor, aggressive power saving
- TLP Power Profiles daemon for easy switching

### Optimized Builds

Custom package overlays with performance flags:
```nix
# Alacritty with mold linker and full LTO
RUSTFLAGS = "-C target-cpu=x86-64-v3 -C lto=fat -C codegen-units=1 -C link-arg=-fuse-ld=mold"
```

## Structure

```
.
├── flake.nix                 # Flake entry point
├── hosts/
│   └── swift-sfx14-71g/      # Host-specific configuration
├── modules/
│   ├── nixos/                # System modules
│   │   ├── boot.nix          # CachyOS kernel, bootloader
│   │   ├── graphics/         # Intel/NVIDIA configuration
│   │   ├── power-management/ # TLP, thermald
│   │   └── ...
│   └── home-manager/         # User modules
│       ├── shell/            # zsh, starship
│       ├── desktop/          # GNOME, extensions
│       ├── programs/         # git, browser
│       └── ...
├── overlays/                 # Package customizations
└── secrets/                  # SOPS encrypted secrets
```

## Stack

| Component| Choice                   |
|----------|--------------------------|
| Kernel   | CachyOS (LTO, x86-64-v3) |
| Desktop  | GNOME + Wayland          |
| Shell    | Zsh + Starship           |
| Terminal | Alacritty                |
| Browser  | Zen Browser              |
| Editor   | VS Code                  |
| Audio    | PipeWire                 |
| Secrets  | SOPS + age               |

## GNOME Setup

- Dash to Dock (bottom, autohide)
- Blur My Shell
- AppIndicator support
- macOS-style window buttons
- Dark mode

## Quick Start

```bash
# Clone
git clone https://github.com/ezozbek36/nix.git
cd nix

# Enter dev shell (includes nixd, alejandra, statix, deadnix)
nix develop

# Build and switch
sudo nixos-rebuild switch --flake .#swift-sfx14-71g

# Or using nh
nh os switch .
```

## Binary Caches

Pre-configured caches for faster builds:
- `nix-community.cachix.org`
- `cuda-maintainers.cachix.org`
- `attic.xuyh0120.win/lantian` (CachyOS kernel)

## Development

```bash
# Format
nix fmt

# Lint
statix check .

# Find dead code
deadnix .
```

## License

MIT
