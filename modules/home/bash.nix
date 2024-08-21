{ ... }:
{
  programs.bash = {
    enable = true;

    profileExtra = ''
      eval "$(direnv hook bash)"
    '';
  };
}
