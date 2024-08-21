{ config, ... }:

{
  sops.secrets.acme_env = { };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;

    resolver = {
      addresses = [ "10.0.0.1" ];
    };

    appendHttpConfig = ''
      map $status $cache_header {
          200     "public";
          302     "public";
          default "no-cache";
      }
    '';

    proxyCachePath."STATIC" = {
      enable = true;
      inactive = "4w";
      keysZoneName = "STATIC";
      keysZoneSize = "10M";
      levels = "1:2";
      maxSize = "25G";
    };

    virtualHosts."cache.husjon.xyz" = {
      addSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # for testing
      email = "jonerling.hustadnes@gmail.com";
    };

    certs."cache.husjon.xyz" = {
      dnsProvider = "cloudflare";
      webroot = null;

      environmentFile = config.sops.secrets.acme_env.path;
      group = "nginx";
    };
  };
}
