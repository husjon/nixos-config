{ pkgs, ... }:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml
  imports = [
    ./blender.nix

    ./mopidy.nix
    ./ncmpcpp.nix
  ];

  home.packages = with pkgs; [
    calibre

    freecad
    godot_4
    krita
    lutris
    prusa-slicer
    tonelib-gfx

    stable.vcv-rack
  ];
}
