{ hostname, lib, ... }:
{
  # TODO: Finalize module

  imports = lib.optional (builtins.pathExists ./${hostname}.nix) ./${hostname}.nix;

  systemd.timers.borgmatic = {
    # not enabled explicitly, it will be picked up automatically when a host has been configured
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "borgmatic.service";
      OnCalendar = "0/4:0"; # run every 4 hours
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };
}
