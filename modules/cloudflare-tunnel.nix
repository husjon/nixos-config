{ config, pkgs, ... }: {
  sops.secrets.cloudflare_tunnel_token = { };
  sops.templates."cloudflared_env".content = ''
    TUNNEL_TOKEN=${config.sops.placeholder.cloudflare_tunnel_token}
  '';

  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = { };

  systemd.services.my_tunnel = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run";
      EnvironmentFile = config.sops.templates."cloudflared_env".path;
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
}
