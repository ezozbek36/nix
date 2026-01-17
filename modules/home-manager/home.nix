# Home Manager configuration
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.username = "ezozbek";
  home.homeDirectory = "/home/ezozbek";

  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    # Utilities
    git
    tree
    ripgrep
    fd
    unzip

    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
  ];

  # ── Browser: Zen ──────────────────────────────────────────────────────────
  programs.zen-browser = {
    enable = true;
  };

  # ── Git ───────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "ezozbek";
    userEmail = "git@ezozbek.dev";
  };

  # ── Shell: Zsh ────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "sudo nixos-rebuild switch --flake $HOME/.nixconfig#default";
    };

    initContent = ''
      # Additional zsh configuration
      bindkey -e  # Emacs keybindings
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';
  };

  # ── Prompt: Starship ──────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Using default preset - clean and informative
      add_newline = true;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold red";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration](bold yellow) ";
      };
    };
  };

  # ── Terminal: Alacritty ───────────────────────────────────────────────────
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 0.98;
        dynamic_title = true;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 12.0;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        blink_interval = 750;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      selection = {
        save_to_clipboard = true;
      };

      keyboard = {
        bindings = [
          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
          {
            key = "Plus";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "Key0";
            mods = "Control";
            action = "ResetFontSize";
          }
        ];
      };
    };
  };

  # ── GNOME Configuration ───────────────────────────────────────────────────
  dconf.settings = {
    # Interface settings
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };

    # Window behavior
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    # Touchpad settings
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      natural-scroll = true;
    };

    # Enable installed extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
      ];
    };

    # Dash to Dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = false;
      autohide = true;
      intellihide = true;
      dash-max-icon-size = 48;
      show-trash = false;
      show-mounts = false;
    };

    # Blur My Shell settings
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
    };
  };

  # ── Home Manager Version ──────────────────────────────────────────────────
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
