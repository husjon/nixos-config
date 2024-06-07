{ config, ... }:

{
  sops.secrets.tailscale_auth_key = { };

  services.tailscale = {
    enable = true;

    # https://login.tailscale.com/admin/settings/keys
    authKeyFile = config.sops.secrets.tailscale_auth_key.path;
  };
}
