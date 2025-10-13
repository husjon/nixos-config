{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  config = lib.mkIf (cfg.user.enable && (config.husjon.graphics.window_manager.default == "sway")) {
    home-manager.users."${cfg.user.username}" = {
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
