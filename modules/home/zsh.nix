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
    historySubstringSearch.enable = true;

    syntaxHighlighting.enable = true;

    initExtra = ''
      zstyle ':completion:*' menu select

      function gcmsg { git commit -m "$1"; }
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
