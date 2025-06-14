{ pkgs, ... }:
let
  dpms_timeout = 10;
  lock_timeout = 10 * 60;

in
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock";
      }

    ];

    timeouts = [
      {
        timeout = dpms_timeout;
        command = "${pkgs.procps}/bin/pgrep swaylock && ${pkgs.sway}/bin/swaymsg output '*' dpms off";
        resumeCommand = "${pkgs.sway}/bin/swaymsg output '*' dpms on";
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
}
