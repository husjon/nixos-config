{ config, lib, ... }:
let
  cfg = config.husjon;

  homeDirectory = config.home-manager.users.${cfg.user.username}.home.homeDirectory;
in
{
  config = lib.mkIf (cfg.user.enable && (cfg.windowManager.default == "hyprland")) {
    home-manager.users."${cfg.user.username}" = {

      services.hyprpaper = {
        enable = true;

        settings = {
          splash = false;

          preload = [ "${homeDirectory}/.wallpaper.png" ];
          wallpaper = [ ", ${homeDirectory}/.wallpaper.png" ];
        };
      };
    };
  };
}
