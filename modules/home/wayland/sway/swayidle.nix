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
}
