{ pkgs, ... }:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml
  imports = [
    ./blender.nix
  ];

  home.packages = with pkgs; [
    krita
  ];
}
