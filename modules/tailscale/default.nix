{ config, ... }:

{
  sops.secrets.tailscale_auth_key = { };

  services.tailscale = {
    enable = true;

    # https://login.tailscale.com/admin/settings/keys
    authKeyFile = config.sops.secrets.tailscale_auth_key.path;
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
}
