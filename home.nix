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
    ghostty = "ghostty";
    hypr = "hypr";
    lazygit = "lazygit";
    kitty = "kitty";
    noctalia = "noctalia";
    nvim = "nvim";
    yazit = "yazi";
  };
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
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
      ".pi".source = create_symlink "${dotfiles}/pi";
    };
  };

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
              email = "brennantduck@continuumcloud.com";
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

    starship = {
      enable = true;
    };

    tmux = {
      enable = true;

      prefix = "C-a";
      mouse = true;
      terminal = "tmux-256color";

      baseIndex = 3;

      focusEvents = true;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;

          extraConfig = ''
            set -g @catppuccin_window_status_style "basic"
            set -g @catppuccin_window_text " #W"
            set -g @catppuccin_window_current_text " #W"
            set -g @catppuccin_status_left_separator "█"


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

            set -as terminal-features 'xterm-kitty:sync@'
          '';
        }
      ];

      extraConfig = ''
        set -g allow-passthrough on
        set -g repeat-time 150


        set -g extended-keys on
        set -g extended-keys-format csi-u

        # set -g status-position top
        bind-key -n C-g display-popup -E -d '#{pane_current_path}' -w 80% -h 80% "exec lazygit"
        unbind t
        bind t display-popup -E -w 80% -h 80% "$SHELL -f"


        set -g set-clipboard on

        setw -g mode-keys vi
        bind -T copy-mode-vi v send-keys -X begin-selection
        #bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.xclip}/bin/xclip -in -selection clipboard'
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'

        # Window navigation
        bind-key -n M-1 select-window -t 1
        bind-key -n M-2 select-window -t 2
        bind-key -n M-3 select-window -t 3
        bind-key -n M-4 select-window -t 4
        bind-key -n M-5 select-window -t 5
        bind-key -n M-6 select-window -t 6
        bind-key -n M-7 select-window -t 7
        bind-key -n M-8 select-window -t 8
        bind-key -n M-9 select-window -t 9 

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
        bind-key -r H resize-pane -L 10
        bind-key -r J resize-pane -D 10
        bind-key -r K resize-pane -U 10
        bind-key -r L resize-pane -R 10

        # Catppuccin window formatting

        # Status bar
        set -g status-justify absolute-centre
        set -g status-right-length 99
        set -g status-left-length 99
        set -g status-left "#{E:@catppuccin_status_session}"

        set -g status-right "#{E:@catppuccin_status_application}"
        #set -agF status-right "#{E:@catppuccin_status_cpu}"
        #set -agF status-right "#{E:@catppuccin_status_ram}"
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

      fastSyntaxHighlighting.enable = true;

      shellAliases = {
        ls = "lsd -a";
        ll = "lsd -alF";
        ot = "nvim -c 'Obsidian today'";
        og = "nvim '~/Documents/cool-vault1/5 - Main Notes/GOALS.md'";
        of = "nvim -c 'Obsidian quick_switch'";
        ta = "tmux a";
        tm = "BDUCK_TMUX_LAYOUT_START_WINDOW=3 BDUCK_TMUX_LAYOUT_SESSION_DIR=~/nixos-env tmuxifier load-session dev";
        hms = "nh search options --scope home-manager";
      };

      initContent = ''
        # History
        setopt append_history
        setopt share_history 
        setopt hist_ignore_dups
        setopt hist_expire_dups_first
        setopt hist_find_no_dups
        setopt no_beep
        setopt inc_append_history

        HISTSIZE=1000000000
        SAVEHIST=1000000000

        export DEJA_ACCEPT_KEY=^Y
        export DEJA_CYCLE_KEY=^N
        export DEJA_FUZZ_KEY=
        export DEJA_FUZZ_BACK_KEY=
        export DEJA_TOGGLE_EMPTY_KEY=

        if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
            source "$HOME/.local/share/deja/init.zsh"
        else
            eval "$(deja init zsh)"
        fi

        bindkey -s ^g "lazygit\n"
        bindkey -s ^f "tmuxifier-sessionizer\n"

        mman() {
            man "$@" | col -bx | bat -l man --style=plain
        }

        eval "$(fzf --zsh)"

        export FZF_DEFAULT_OPTS='
          --layout=reverse
          --color=bg:#16181a,fg:#ffffff,hl:#5ef1ff
          --color=bg+:#3c4048,fg+:#ffffff,hl+:#5ef1ff
          --color=border:#3c4048,header:#5ea1ff,gutter:#16181a
          --color=spinner:#f1ff5e,info:#5ef1ff
          --color=pointer:#bd5eff,marker:#5eff6c,prompt:#5ea1ff
        '
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
      '';

    };
  };

  services = {
    easyeffects = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    adw-gtk3
    bat
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
    lsd
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
    seer
    slurp
    spacetimedb
    statix
    stremio-linux-shell
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
    zoxide
    inputs.helium.packages.${system}.default
  ];

  home.stateVersion = "26.05"; # Keep the version from the first Home Manager install.
}
