{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  options.husjon.services.mpd.enable = lib.mkEnableOption "mpd";

  config = lib.mkIf cfg.services.mpd.enable {
    home-manager.users."${cfg.user.username}" = {
      services.mpd = {
        enable = true;

        musicDirectory = "~/music";

        extraConfig = ''
          audio_output {
              type "pipewire"
              name "output"
          }
        '';
      };

      services.mpd-mpris = {
        enable = true;

        mpd = {
          host = "127.0.0.1";
          useLocal = false;
        };
      };
    };
  };
}
