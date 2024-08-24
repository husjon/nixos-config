{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    package = pkgs.unstable.neovim-unwrapped;
  };
}
