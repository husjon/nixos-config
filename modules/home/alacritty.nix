{ pkgs, ... }:
let
  catppuccin-alacritty = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    rev = "343cf8d65459ac8f6449cc98dd3648bcbd7e3766";
    hash = "sha256-5MUWHXs8vfl2/u6YXB4krT5aLutVssPBr+DiuOdMAto=";
  };
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      import = [ "${catppuccin-alacritty}/catppuccin-mocha.toml" ];

      shell = "${pkgs.fish}/bin/fish";

      env = {
        TERM = "xterm-256color";
      };
    };
  };
}
