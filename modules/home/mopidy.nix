{ pkgs, ... }:
{
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [
      mopidy-mpd
      mopidy-mpris
    ];

    settings = {
      audio = {
        mixer_volume = 5;
      };

      core = {
        restore_state = true;
      };

      file.media_dirs = [
        "~/music"
      ];

      mpd = {
        enabled = true;
        hostname = "127.0.0.1";
        port = 6600;
        max_connections = 20;
        connection_timeout = 5;
      };
    };

  };
}
