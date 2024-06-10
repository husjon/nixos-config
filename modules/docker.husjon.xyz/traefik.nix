{ config, ... }:

{
  sops.secrets.traefik_env = { };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  users.users."traefik".extraGroups = [ "docker" ];


  services.traefik = {

    enable = true;

    environmentFiles = [
      config.sops.secrets.traefik_env.path
    ];

    staticConfigOptions = {
      api.insecure = true;
      api.dashboard = true;

      entrypoints.web.address = ":80";
      entrypoints.http.http.redirections.entrypoint.to = "websecure";
      entrypoints.http.http.redirections.entrypoint.scheme = "https";
      entrypoints.websecure.address = ":443";

      providers.docker.endpoint = "unix:///var/run/docker.sock";
      providers.docker.exposedByDefault = true;
      providers.docker.defaultRule = "Host(`{{ .ContainerName }}.husjon.xyz`)";

      certificatesResolvers.cloudflare.acme.dnsChallenge.provider = "cloudflare";
      certificatesResolvers.cloudflare.acme.storage = "/var/lib/traefik/acme.json";
    };
  };
}
