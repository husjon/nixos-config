{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
in
{
  options.husjon.services.mopidy.enable = lib.mkEnableOption "mopidy";

  config = lib.mkIf (cfg.user.enable && cfg.services.mopidy.enable) {
    home-manager.users."${cfg.user.username}" = {
      systemd.user.services.mopidy-scan = {
        Service.Type = lib.mkForce "simple";
        Install = lib.mkForce { };
      };

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
    };
  };
}
