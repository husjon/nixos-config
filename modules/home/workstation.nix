{ pkgs, ... }:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml
  imports = [
    ./blender.nix
  ];

  home.packages = with pkgs; [
    calibre

    freecad
    godot_4
    krita
    lutris
    prusa-slicer
    tonelib-gfx

    vcv-rack
  ];
}
