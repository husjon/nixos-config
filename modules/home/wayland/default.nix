{ pkgs, ... }:
{
  imports = [
    ./fuzzel.nix
    ./mako.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp

    wl-clipboard
  ];
}
