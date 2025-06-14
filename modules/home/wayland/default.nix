{ pkgs, ... }:
{
  imports = [
    ./sway

    ./fuzzel.nix
    ./mako.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp

    wl-clipboard
  ];
}
