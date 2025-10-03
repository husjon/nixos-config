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
      };
    };
  };
}
