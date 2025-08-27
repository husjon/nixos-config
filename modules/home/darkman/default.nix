{ pkgs, ... }:
let
  gtkTheme = (
    mode: ''
      ${pkgs.dconf}/bin/dconf write \
          /org/gnome/desktop/interface/color-scheme "'prefer-${mode}'"
    ''
  );

  neovim = (mode: ''echo "${mode}" >~/.cache/current-theme'');

in
{
  imports = [
    ./sway.nix
    ./tmux.nix
    ./wallpaper.nix
  ];

  services.darkman = {
    enable = true;

    darkModeScripts = {
      gtk-theme = gtkTheme "dark";
      neovim = neovim "dark";
    };

    lightModeScripts = {
      gtk-theme = gtkTheme "light";
      neovim = neovim "light";
    };
  };
}
