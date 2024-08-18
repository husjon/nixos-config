{ ... }:
{
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;

    prefix = "C-space";

    terminal = "xterm-256color:Tc"; # Allow 24-bit color support

    extraConfig = ''
      # check if active pane is vim/neovim
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key | split-window -h -c "#{pane_current_path}"
      bind-key - split-window -v -c "#{pane_current_path}"
      bind-key c new-window   -c "#{pane_current_path}"  # create new window in current directory
      bind-key -n M-S         new-session

      bind-key m select-pane -m  # Marks the pane (same as right click)
      bind-key M swap-pane

      bind-key -T copy-mode-vi 'v' send -X begin-selection  # VIM-esque selection and yank (tmux >2.3)
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xsel -i -b'
      bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel 'xsel -i -b'

      bind-key -n M-a         set synchronize-panes on    \; display "Sync on"
      bind-key -n M-o         set synchronize-panes off   \; display "Sync off"

      bind-key -n M-h         if-shell "$is_vim" "send-keys M-h"  "select-pane -L"  # pass on binding to vim / neovim
      bind-key -n M-j         if-shell "$is_vim" "send-keys M-j"  "select-pane -D"
      bind-key -n M-k         if-shell "$is_vim" "send-keys M-k"  "select-pane -U"
      bind-key -n M-l         if-shell "$is_vim" "send-keys M-l"  "select-pane -R"
      bind-key -n C-\         if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind-key -n M-H         select-pane -L
      bind-key -n M-J         select-pane -D
      bind-key -n M-K         select-pane -U
      bind-key -n M-L         select-pane -R

      bind-key -n M-C-h       resize-pane -L 1
      bind-key -n M-C-j       resize-pane -D 1
      bind-key -n M-C-k       resize-pane -U 1
      bind-key -n M-C-l       resize-pane -R 1
      bind-key -r M-C-H       resize-pane -L 10
      bind-key -r M-C-J       resize-pane -D 10
      bind-key -r M-C-K       resize-pane -U 10
      bind-key -r M-C-L       resize-pane -R 10

      bind-key C-s             split-window -v "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
    '';
  };
}
