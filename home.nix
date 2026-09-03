{
  inputs,
  pkgs,
  config,
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
    lazygit = "lazygit";
    kitty = "kitty";
    mango = "mango";
    noctalia = "noctalia";
    nvim = "nvim";
    yazit = "yazi";
  };
in
{
  home = {
    username = "bduck";
    homeDirectory = "/home/bduck";
    file = {
      ".face".source = ./assets/face.jpg;
      "Pictures/Wallpapers".source = create_symlink "${assets}/wallpapers";
      ".tmux-layouts".source = create_symlink "${dotfiles}/tmuxifier";
      ".local/bin".source = create_symlink "${dotfiles}/scripts";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  programs = {
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
      };

      includes = [
        {
          condition = "gitdir:~/Work/";
          contents = {
            user = {
              email = "brennantduck@continuumcloud.com";
            };
          };
        }
      ];
    };

    starship = {
      enable = true;
    };

    tmux = {
      enable = true;

      prefix = "C-a";
      mouse = true;
      terminal = "tmux-256color";
      baseIndex = 3;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;

          extraConfig = ''
            set -g @catppuccin_window_status_style "basic"
            set -g @catppuccin_window_text " #W"
            set -g @catppuccin_window_current_text " #W"

            # --> Catppuccin (Cyberdream)
            set -ogq @thm_bg "#16181a"
            set -ogq @thm_fg "#ffffff"

            # Colors
            set -ogq @thm_rosewater "#ff5ea0"
            set -ogq @thm_flamingo "#ff5ea0"
            set -ogq @thm_pink "#ff5ea0"
            set -ogq @thm_mauve "#ff5ef1"
            set -ogq @thm_red "#ff6e5e"
            set -ogq @thm_maroon "#ffbd5e"
            set -ogq @thm_peach "#ffbd5e"
            set -ogq @thm_yellow "#f1ff5e"
            set -ogq @thm_green "#5eff6c"
            set -ogq @thm_teal "#5ef1ff"
            set -ogq @thm_sky "#5ef1ff"
            set -ogq @thm_sapphire "#5ef1ff"
            set -ogq @thm_blue "#5ea1ff"
            set -ogq @thm_lavender "#bd5eff"

            # Surfaces and overlays
            set -ogq @thm_subtext_1 "#7b8496"
            set -ogq @thm_subtext_0 "#7b8496"
            set -ogq @thm_overlay_2 "#3c4048"
            set -ogq @thm_overlay_1 "#3c4048"
            set -ogq @thm_overlay_0 "#3c4048"
            set -ogq @thm_surface_2 "#1e2124"
            set -ogq @thm_surface_1 "#1e2124"
            set -ogq @thm_surface_0 "#1e2124"
            set -ogq @thm_mantle "#1e2124"
            set -ogq @thm_crust "#1e2124"

          '';
        }
      ];

      extraConfig = ''
        set -g allow-passthrough on
        set -g repeat-time 1000


        set -g extended-keys on
        set -g extended-keys-format csi-u

        setw -g mode-keys vi
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.xclip}/bin/xclip -in -selection clipboard'

        # Pane navigation
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # Swap panes
        bind-key -r C-h swap-pane -s '{left-of}'
        bind-key -r C-j swap-pane -s '{down-of}'
        bind-key -r C-k swap-pane -s '{up-of}'
        bind-key -r C-l swap-pane -s '{right-of}'

        # Resize panes
        bind-key -r H resize-pane -L 20
        bind-key -r J resize-pane -D 10
        bind-key -r K resize-pane -U 10
        bind-key -r L resize-pane -R 20

        setw -g automatic-rename off
        setw -g allow-rename off

        # Catppuccin window formatting

        # Status bar
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""

        set -g status-right "#{E:@catppuccin_status_application}"
        # set -agF status-right "#{E:@catppuccin_status_cpu}"
        # set -agF status-right "#{E:@catppuccin_status_ram}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        set -ag status-right "#{E:@catppuccin_status_uptime}"
        # set -agF status-right "#{E:@catppuccin_status_battery}"
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "robbyrussell";
      };
      shellAliases.ls = "lsd";
      shellAliases.ll = "lsd -alF";
      initContent = ''
        bindkey -s ^g "lazygit\n"
        bindkey -s ^a "tmux a\n"
        bindkey -s ^f "tmuxifier-sessionizer\n"
      '';

    };
  };

  home.packages = with pkgs; [
    bat
    clang
    clang-tools
    cmake
    delta
    delve
    discord
    efm-langserver
    emmet-ls
    firefox
    fzf
    gdb
    ghostty
    go
    gofumpt
    gopls
    jetbrains.goland
    kitty
    lazygit
    lsd
    lua5_1
    lua-language-server
    luarocks
    neovim
    nil
    nixfmt
    ninja
    nodejs
    prettierd
    python3
    obsidian
    readest
    ripgrep
    rustup
    slurp
    spotify
    statix
    stremio-linux-shell
    stylua
    tailwindcss
    television
    templ
    tmuxifier
    tree-sitter
    typescript-language-server
    unzip
    wl-clipboard
    xwayland-satellite
    yazi
    zoxide
    inputs.helium.packages.${system}.default
  ];

  home.stateVersion = "26.05"; # Keep the version from the first Home Manager install.
}
