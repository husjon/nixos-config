{ ... }:
{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      # commands will be expanded when entered
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

    shellAliases = {
      v = "$EDITOR";
      vrc = "pushd ~/.config/nvim/; $EDITOR init.lua; popd";
    };

    shellInitLast = ''
      set -gx EDITOR nvim
      set -gx QT_QPA_PLATFORMTHEME qt5ct

      set fish_greeting  # disables greeting

      function gcmsg; git commit -m $argv; end
    '';
  };
}
