{ ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {

      color = "000000";
      image = "~/.cache/wallpaper.lock.png";
      daemonize = true;

      show-failed-attempts = true;
    };
  };
}
