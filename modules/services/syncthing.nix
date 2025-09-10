{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  options.husjon.services.syncthing.enable = lib.mkOption {
    description = "Whether to enable syncthing";
    default = true;
    example = false;
  };

  config = lib.mkIf (cfg.user.enable && cfg.services.syncthing.enable) {
    home-manager.users."${cfg.user.username}" = {
      services.syncthing.enable = true;
    };

    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [
      21027
      22000
    ];
  };
}
