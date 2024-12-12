{ ... }:
{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "history"
      "completion"
    ];

    defaultKeymap = "viins"; # vim insert-mode

    enableCompletion = true;

    history.ignorePatterns = [
      "reboot"
    ];

    syntaxHighlighting.enable = true;

    initExtra = ''
      zstyle ':completion:*' menu select

      function gcmsg { git commit -m "$1"; }
      function reset {
          if [ ! -z $TMUX ]; then
              clear; tmux clear-history
          else
              /usr/bin/env reset
          fi
      }

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # history-substring-search {{{
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "$key[Up]"    up-line-or-beginning-search
      bindkey "$key[Down]"  down-line-or-beginning-search
      # }}}

      # docker completion from zsh-completion isn't complete, we'll source it from docker itself instead
      type docker >/dev/null && source <(docker completion zsh)
    '';

    shellAliases = {
      ll = "ls -l";

      v = "$EDITOR";
      vrc = "pushd ~/.config/nvim/; $EDITOR init.lua; popd";

      ga = "git add";
      gb = "git branch";
      "gc!" = "git commit --amend";
      gc = "git commit";
      gcb = "git checkout -b";
      gco = "git checkout";
      gd = "git diff";
      gl = "git pull";
      glog = "git log";
      gm = "git merge";
      gp = "git push";
      grb = "git rebase";
      grbi = "git rebase --interactive";
      gs = "git status";
      gsw = "watch --color -n 1 git -c color.ui=always status";
      gst = "git stash";
      gstp = "git stash pop";

      rm = "trash";
    };
  };
}
