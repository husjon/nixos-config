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
    '';
  };
}
