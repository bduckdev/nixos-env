{ pkgs, ... }:
{
  programs.tmux = {
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
      set -g visual-activity off 


      set -g extended-keys on
      set -g extended-keys-format csi-u

      #set -g status-position top
      bind-key o display-popup -E -d '#{pane_current_path}' -w 80% -h 80% "exec nvim -c 'Obsidian today'"
      bind-key g display-popup -E -d '#{pane_current_path}' -w 80% -h 80% "exec lazygit"
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
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-l select-pane -R


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

      set -g status-style 'bg=default'
      set -g status-right "#{E:@catppuccin_status_application}"
      #set -agF status-right "#{E:@catppuccin_status_cpu}"
      #set -agF status-right "#{E:@catppuccin_status_ram}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      # set -agF status-right "#{E:@catppuccin_status_battery}"
    '';
  };
}
