{ lib, pkgs, ... }:
{
  systemd.user.services.mopidy-scan = lib.mkForce { }; # disable mopidy-scan on restart (takes multiple minutes)
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [
      mopidy-mpd
      mopidy-mpris
      mopidy-local
    ];

    settings = {
      audio = {
        mixer_volume = 5;
      };

      core = {
        restore_state = true;
      };

      local.media_dir = "~/music";

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
