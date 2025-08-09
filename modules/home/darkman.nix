{ lib, pkgs, ... }:
let
  gtkThemeScript = (
    mode: ''
      ${pkgs.dconf}/bin/dconf write \
          /org/gnome/desktop/interface/color-scheme "'prefer-${mode}'"
    ''
  );

  wallpaperScript = (
    mode: ''
      PIDS=$(${pkgs.procps}/bin/pgrep swaybg)

      ${lib.getExe pkgs.swaybg} \
        --output '*' \
        --mode fill \
        --image ~/.wallpaper.${mode}.png &

      ${pkgs.coreutils-full}/bin/ln -fs ~/.wallpaper.${mode}.png ~/.wallpaper.png

      ${pkgs.coreutils-full}/bin/sleep 0.25
      kill ''${PIDS}
    ''
  );

in
{
  services.darkman = {
    enable = true;

    darkModeScripts = {
      gtk-theme = gtkThemeScript "dark";

      wallpaper = wallpaperScript "dark";
    };

    lightModeScripts = {
      gtk-theme = gtkThemeScript "light";

      wallpaper = wallpaperScript "light";
    };
  };
}
