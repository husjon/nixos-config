{ config, lib, ... }:
let
  cfg = config.husjon.services.docker;
in
{
  options.husjon.services.docker.enable = lib.mkEnableOption "docker on the system";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
