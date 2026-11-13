{ _, ... }: {
  programs = {
    zsh = {
      enable = true;

      fastSyntaxHighlighting.enable = true;

      shellAliases = {
        ls = "eza -lh --group-directories-first --icons=auto";
        ll = "eza -lh --group-directories-first --icons=auto";
        la = "eza -lha --group-directories-first --icons=auto";
        o = "nvim -c 'Obsidian'";
        ot = "nvim -c 'Obsidian today'";
        og = "nvim '~/Documents/cool-vault1/5 - Main Notes/GOALS.md'";
        of = "nvim -c 'Obsidian quick_switch'";
        ta = "tmux a";
        hm = ''herdr-project "$HOME/nixos-env"'';
        tm = "BDUCK_TMUX_LAYOUT_START_WINDOW=3 BDUCK_TMUX_LAYOUT_SESSION_DIR=~/nixos-env tmuxifier load-session dev";
        tn = "tmuxifier load-session notes";
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

    starship = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
