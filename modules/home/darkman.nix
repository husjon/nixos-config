{ pkgs, ... }:
let
  gtkThemeScript = (
    mode: ''
      ${pkgs.dconf}/bin/dconf write \
          /org/gnome/desktop/interface/color-scheme "'prefer-${mode}'"
    ''
  );

in
{
  services.darkman = {
    enable = true;

    darkModeScripts = {
      gtk-theme = gtkThemeScript "dark";
    };

    lightModeScripts = {
      gtk-theme = gtkThemeScript "light";
    };
  };
}
