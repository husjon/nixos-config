{
  lib,
  pkgs,
  ...
}:
let
  wallpaper = (
    mode: ''
      PIDS=''$(${pkgs.procps}/bin/pgrep swaybg)

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
    darkModeScripts.wallpaper = wallpaper "dark";
    lightModeScripts.wallpaper = wallpaper "light";
  };
}
