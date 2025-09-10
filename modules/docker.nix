{ config, lib, ... }:
let
  cfg = config.husjon.docker;
in
{
  options.husjon.docker.enable = lib.mkEnableOption "docker on the system";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
