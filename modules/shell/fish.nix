{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
in
{
  config = lib.mkIf (cfg.user.enable && (builtins.elem pkgs.fish cfg.user.shells)) {
    home-manager.users."${cfg.user.username}" = {
      # Nix completion for fish (https://discourse.nixos.org/t/how-to-use-completion-fish-with-home-manager/23356/4)
      xdg.configFile."fish/completions/nix.fish".source =
        "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";

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

        shellInit = ''
          fish_vi_key_bindings
          bind -M insert \ck up-or-search
          bind -M insert \cj down-or-search
          bind -M insert \cr history-pager
        '';

        shellInitLast = ''
          set -gx EDITOR nvim
          set -gx QT_QPA_PLATFORMTHEME qt5ct

          set fish_greeting  # disables greeting

          function gcmsg; git commit -m $argv; end

          function reset
              if set -q TMUX
                  clear; tmux clear-history
              else
                  /usr/bin/env reset
              end
          end
        '';
      };
    };
  };
}
