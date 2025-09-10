{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;

  dpms_timeout = 10;
  lock_timeout = 10 * 60;

  lockScript = pkgs.writeScriptBin "swayidle-lock" ''
    SHA256_FILE=''${XDG_CACHE_HOME}/wallpaper.png.sha256

    if ! ${pkgs.coreutils}/bin/sha256sum --check ''${SHA256_FILE}; then
      ${pkgs.coreutils}/bin/sha256sum ~/.wallpaper.png > ''${SHA256_FILE}
      ${lib.getExe pkgs.imagemagick} ~/.wallpaper.png -scale 20% -modulate 50,20 -scale 500% ~/.cache/wallpaper.lock.png
    fi

    ${lib.getExe pkgs.swaylock}
  '';

in
{
  config = lib.mkIf (cfg.user.enable && (config.husjon.graphics.window_manager == "sway")) {
    home-manager.users."${cfg.user.username}" = {
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "lock";
            command = "${lib.getExe lockScript}";
          }
          {
            event = "before-sleep";
            command = "${pkgs.systemd}/bin/loginctl lock-session";
          }
        ];

        timeouts = [
          {
            timeout = dpms_timeout;
            command = "${pkgs.procps}/bin/pgrep swaylock && ${pkgs.sway}/bin/swaymsg output '*' dpms off";
            resumeCommand = builtins.concatStringsSep "; " [
              "${pkgs.sway}/bin/swaymsg output '*' dpms on > /dev/null"
              "${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary"
            ];
          }
          {
            timeout = lock_timeout - 1;
            command = "${pkgs.libnotify}/bin/notify-send swayidle locking";
          }
          {
            timeout = lock_timeout;
            command = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = lock_timeout + dpms_timeout;
            command = "${pkgs.sway}/bin/swaymsg output '*' dpms off";
          }
        ];
      };
    };
  };
}
