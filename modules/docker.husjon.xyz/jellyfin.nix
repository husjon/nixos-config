{ config, ... }:
{
  sops.secrets.cifs_username = { };
  sops.secrets.cifs_password = { };
  sops.templates."mnt-media-cifs".content = ''
    username=${config.sops.placeholder.cifs_username}
    password=${config.sops.placeholder.cifs_password}
  '';

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      "jellyfin" = {
        image = "jellyfin/jellyfin";
        hostname = "jellyfin";

        labels = {
          "traefik.http.routers.jellyfin.tls" = "true";
          "traefik.http.routers.jellyfin.tls.certresolver" = "cloudflare";
        };

        volumes = [
          "jellyfin-config:/config"
          "jellyfin-cache:/cache"

          "/mnt/media:/media"
        ];
      };
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
