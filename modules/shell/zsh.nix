{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;
in
{
  config = lib.mkIf (builtins.elem pkgs.zsh cfg.shells) {
    environment.pathsToLink = [ "/share/zsh" ];

    programs.zsh.enable = true;

    home-manager.users."${cfg.username}" = {
      programs.zsh = {
        enable = true;

        autosuggestion.enable = true;
        autosuggestion.strategy = [
          "history"
          "completion"
        ];

        defaultKeymap = "viins"; # vim insert-mode

        enableCompletion = true;

        history = {
          append = true;
          expireDuplicatesFirst = true;

          ignorePatterns = [
            "reboot"
          ];

        };
        historySubstringSearch.enable = true;

        syntaxHighlighting.enable = true;

        initContent = ''
          zstyle ':completion:*' menu select

          function gcmsg { git commit -m "$1"; }
          function reset {
              if [ ! -z $TMUX ]; then
                  clear; tmux clear-history
              else
                  /usr/bin/env reset
              fi
          }

          function web {
            docker stop simple-web-server >/dev/null 2>&1

            if [[ $1 == 'stop' ]]; then
              echo "Stopped webserver"
              return
            fi

            CONTAINER=$(docker run -d --rm -ti --volume "`pwd`:/usr/share/nginx/html:ro" --name simple-web-server -p 127.0.0.1:5500:80 nginx)
            docker exec -tid ''${CONTAINER} bash -c "sleep 3600 && kill 1"
            echo "Started webserver running at: http://localhost:5500 (for 1 hour)"
            echo "Sharing current folder: ''${PWD}"
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
    };
  };
}
