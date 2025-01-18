{ pkgs, ... }:

{
  systemd.user.timers = {
    home-manager-maintenance = {
      Unit = {
        Description = "Run generation cleanup daily";
      };

      Timer = {
        OnCalendar = "daily";
        Unit = "home-manager-maintenance.service";
      };
    };
  };
  systemd.user.services = {

    home-manager-maintenance = {
      Unit = {
        Description = "Cleanup of home manager generations older than 14 days";
      };

      Service = {
        ExecStart = "${pkgs.nix}/bin/nix-env --profile \${HOME}/.local/state/nix/profiles/home-manager --delete-generations +14d";
      };
    };
  };
}
