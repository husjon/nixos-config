{ config, lib, ... }:
let
  cfg = config.husjon.system.hibernation;
in
{
  options.husjon.system.hibernation.enable = lib.mkEnableOption "hibernation";

  config = lib.mkIf cfg.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
      HibernateOnACPower=false
    '';
  };
}
