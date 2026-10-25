{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  dotfiles = "${config.home.homeDirectory}/nixos-env/config";
  assets = "${config.home.homeDirectory}/nixos-env/assets";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    bat = "bat";
    delta = "delta";
    ghostty = "ghostty";
    herdr = "herdr";
    hypr = "hypr";
    lazygit = "lazygit";
    kitty = "kitty";
    noctalia = "noctalia";
    nvim = "nvim";
    swayimg = "swayimg";
    yazi = "yazi";
  };
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];
  home = {
    username = "bduck";
    homeDirectory = "/home/bduck";
    file = {
      ".face".source = ./assets/face.jpg;
      "Pictures/Wallpapers".source = create_symlink "${assets}/wallpapers";
      ".tmux-layouts".source = create_symlink "${dotfiles}/tmuxifier";
      ".local/bin".source = create_symlink "${dotfiles}/scripts";
      ".pi".source = create_symlink "${dotfiles}/pi";
    };
  };

  # The plugin registry is machine-local; install Sessionizer after linking configs.
  home.activation.herdrSessionizer = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.coreutils}/bin/env \
      PATH="${
        lib.makeBinPath [
          pkgs.herdr
          pkgs.bun
          pkgs.nodejs
          pkgs.git
          pkgs.jq
          pkgs.fzf
        ]
      }:$PATH" \
      ${pkgs.bash}/bin/bash "${dotfiles}/scripts/herdr-sessionizer-setup"
  '';

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf = {
    enable = true;

    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = false;
      vimdiffAlias = true;

      sideloadInitLua = true;

      extraLuaPackages = ps: [ ps.magick ];

      extraPackages = [
        pkgs.imagemagick
        pkgs.ghostscript # Required only when rendering PDF files
      ];
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bduck/nixos-env/";
    };

    git = {
      enable = true;

      settings = {
        user = {
          name = "Brennan Duck";
          email = "brennantduck@gmail.com";
        };

        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        pull.rebase = true;
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        diff.tool = "nvimdiff";
        difftool.prompt = false;
        merge.tool = "nvimdiff";
        mergetool.prompt = false;

        delta = {
          features = "cyberdream";
          navigate = true;
          dark = true;
        };
      };

      includes = [
        {
          path = "${config.home.homeDirectory}/.config/delta/themes/cyberdream.gitconfig";
        }
        {
          condition = "gitdir:~/Work/";
          contents = {
            user = {
              email = "bduck@continuumcloud.com";
            };
          };
        }
      ];
    };

    spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        #hidePodcasts
        #shuffle
      ];
      theme = spicePkgs.themes.text;
    };

  };

  services = {
    easyeffects = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";

    qt5ctSettings.Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt5ct/colors/noctalia.conf";
    };

    qt6ctSettings.Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
    };
  };

  home.packages = with pkgs; [
    adw-gtk3
    bat
    blanket
    bottles
    bun
    clang
    clang-manpages
    clang-tools
    cmake
    codex
    deja
    delta
    delve
    discord
    efm-langserver
    emmet-ls
    eza
    fastfetch
    fd
    firefox
    fzf
    gdb
    ghostty
    gnumake
    go
    gofumpt
    gopls
    herdr
    heroic
    imagemagick
    jetbrains.goland
    jetbrains.idea
    jq
    kitty
    lazygit
    linux-wallpaperengine
    lua5_1
    lua-language-server
    luarocks
    man-pages
    mgba
    mpvpaper
    lutris
    nil
    nix-output-monitor
    nixfmt
    ninja
    nodejs
    nvd
    obs-studio
    pavucontrol
    pi-coding-agent
    prettierd
    protonup-qt
    python3
    obsidian
    readest
    retroarch
    revive
    ripgrep
    rustup
    satty
    seer
    slurp
    spacetimedb
    statix
    stremio-linux-shell
    swayimg
    stylua
    tailwindcss
    television
    telegram-desktop
    templ
    tetrio-desktop
    tldr
    tmuxifier
    tree-sitter
    typescript-language-server
    unzip
    wlr-randr
    yazi
    zotero
    zoxide
    inputs.helium.packages.${system}.default
  ];

  home.stateVersion = "26.05"; # Keep the version from the first Home Manager install.
}
