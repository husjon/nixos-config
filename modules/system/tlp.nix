{ config, lib, ... }:
let
  cfg = config.husjon.system.tlp;
in
{
  options.husjon.system.tlp.enable = lib.mkEnableOption "tlp for laptops";

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
    };

    services.upower = {
      enable = true;

      percentageLow = 15;
      percentageCritical = 5;
      criticalPowerAction = "Hibernate"; # one of "PowerOff", "Hibernate", "HybridSleep"
    };
  };
}
