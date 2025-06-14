{ ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {

      color = "000000";
      image = "~/.wallpaper.lock.png";
      daemonize = true;

      show-failed-attempts = true;
    };
  };
}
