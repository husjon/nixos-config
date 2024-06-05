{ config, ... }:

{
  sops.secrets.acme_env = { };
  sops.secrets.cifs_username = { };
  sops.secrets.cifs_password = { };
  sops.templates."mnt-media-cifs".content = ''
    username=${config.sops.placeholder.cifs_username}
    password=${config.sops.placeholder.cifs_password}
  '';

  services.jellyfin = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."jellyfin.husjon.xyz" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8096";
      };
    };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # for testing
      email = "jonerling.hustadnes@gmail.com";
    };

    certs."jellyfin.husjon.xyz" = {
      dnsProvider = "cloudflare";
      webroot = null;

      environmentFile = config.sops.secrets.acme_env.path;
      group = "nginx";
    };
  };

  fileSystems."/mnt/media" = {
    device = "//diskstation420/multimedia";
    fsType = "cifs";

    options = [
      "credentials=${config.sops.templates."mnt-media-cifs".path}"
      "x-systemd.automount"
      "noauto"
    ];
  };
}
