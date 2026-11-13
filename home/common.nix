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
    ./modules/firefox.nix
    ./modules/zsh.nix
  ];
  home = {
    username = "bduck";
    file = {
      ".face".source = ../assets/face.jpg;
      "Pictures/Wallpapers".source = create_symlink "${assets}/wallpapers";
      ".tmux-layouts".source = create_symlink "${dotfiles}/tmuxifier";
      ".local/bin".source = create_symlink "${dotfiles}/scripts";
      ".pi".source = create_symlink "${dotfiles}/pi";
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
        pkgs.ghostscript
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

  home.packages = with pkgs; [
    bat
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
    fzf
    ghostty
    gnumake
    go
    gofumpt
    gopls
    herdr
    imagemagick
    jetbrains.goland
    jetbrains.idea
    jq
    kitty
    lazygit
    lua5_1
    lua-language-server
    luarocks
    man-pages
    nil
    nix-output-monitor
    nixfmt
    ninja
    nodejs
    obs-studio
    pavucontrol
    pi-coding-agent
    prettierd
    proton-vpn
    python3
    obsidian
    readest
    revive
    ripgrep
    rustup
    spacetimedb
    statix
    swayimg
    stylua
    tailwindcss
    television
    telegram-desktop
    templ
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
