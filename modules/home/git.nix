{ pkgs, ... }:
{
  home.packages = with pkgs; [ git-crypt ];

  programs.git = {
    enable = true;
  };
}
