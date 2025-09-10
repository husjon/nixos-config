{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  options.husjon.services.tailscale = {
    enable = lib.mkOption {
      description = "Wheather to enable tailscale for the system";
      default = true;
    };

    exitNode = lib.mkEnableOption "this node as an exit node";
  };

  config = lib.mkIf cfg.services.tailscale.enable {
    sops.secrets.tailscale_auth_key = { };

    services.tailscale = {
      enable = true;

      # https://login.tailscale.com/admin/settings/keys
      authKeyFile = config.sops.secrets.tailscale_auth_key.path;

      useRoutingFeatures = if cfg.services.tailscale.exitNode then "server" else "client";

      extraSetFlags =
        if cfg.services.tailscale.exitNode then
          [
            "--advertise-exit-node"
            "--advertise-routes=10.0.0.0/24"
          ]
        else
          [ ];
    };

    systemd.services."tailscale-post_hibernate_restart" = {
      enable = true;

      script = "systemctl restart tailscaled";

      after = [
        "hibernate.target"
        "suspend.target"
      ];
      wantedBy = [
        "hibernate.target"
        "suspend.target"
      ];
    };
  };
}
