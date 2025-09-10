{ config, lib, ... }:
let
  cfg = config.husjon.system.bluetooth;
in
{
  options.husjon.system.bluetooth.enable = lib.mkOption {
    description = "Wheather to enable bluetooth on this system";
    default = true;
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
