{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  config = lib.mkIf (cfg.user.enable && (cfg.windowManager.default == "hyprland")) {
    home-manager.users."${cfg.user.username}" = {
      services.hypridle = {
        enable = true;

        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock"; # dbus/sysd lock command (loginctl lock-session)
            ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
          };

          listener = [
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 630;
              on-timeout = "hyprctl dispatch dpms off";
            }
            {
              timeout = 30;
              on-timeout = "pgrep hyprlock && hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
