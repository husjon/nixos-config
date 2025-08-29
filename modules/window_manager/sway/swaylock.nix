{ config, lib, ... }:
{
  config = lib.mkIf (config.husjon.graphics.window_manager == "sway") {
    home-manager.users."${config.husjon.user.username}" = {
      programs.swaylock = {
        enable = true;
        settings = {

          color = "000000";
          image = "~/.cache/wallpaper.lock.png";
          daemonize = true;

          show-failed-attempts = true;
        };
      };
    };
  };
}
