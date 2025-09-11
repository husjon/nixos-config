{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.programs.steam;
in
{
  options.husjon.programs.steam = {
    enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true;

        gamescopeSession.enable = true;
        protontricks.enable = true;

        package = pkgs.steam.override {
          extraPkgs =
            pkgs: with pkgs; [
              mangohud
            ];
        };
      };
    };
  };
}
