{ ... }:
{
  programs.bash = {
    enable = true;

    historyControl = [ "ignoreboth" ];

    profileExtra = ''
      eval "$(direnv hook bash)"
    '';
  };
}
