{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;

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
  config = {
    home-manager.users."${cfg.username}" = {
      services.darkman = {
        darkModeScripts.wallpaper = wallpaper "dark";
        lightModeScripts.wallpaper = wallpaper "light";
      };
    };
  };
}
