{ config, lib, ... }:
let
  cfg = config.husjon.system.hibernation;
in
{
  options.husjon.system.hibernation.enable = lib.mkEnableOption "hibernation";

  config = lib.mkIf cfg.enable {
    services.logind.lidSwitch = "suspend-then-hibernate";
    services.logind.powerKey = "suspend-then-hibernate";
    services.logind.powerKeyLongPress = "poweroff";

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
      HibernateOnACPower=false
    '';
  };
}
