{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  options.husjon.programs.rmpc.enable = lib.mkEnableOption "rmpc";

  config = lib.mkIf cfg.programs.rmpc.enable {
    home-manager.users."${cfg.user.username}" = {
      programs.rmpc = {
        enable = true;
      };
    };
  };
}
