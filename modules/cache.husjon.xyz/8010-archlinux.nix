{ ... }:

{
  services.nginx = {
    virtualHosts."cache" = {
      locations."~ ^/archlinux/(.*?\.(iso|qcow2)(\.(sig|SHA256))?)$" = {
        extraConfig = ''
          proxy_pass        http://archlinux/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/archlinux/(.*?\.tar\.(xz|zst))$" = {
        extraConfig = ''
          proxy_pass        http://archlinux/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/archlinux/(.*?\.(db|sig|files|txt))$" = {
        extraConfig = ''
          proxy_pass        http://archlinux/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
    };

    upstreams."archlinux" = {
      servers = {
        "127.0.0.1:8011" = { };
        "127.0.0.1:8012" = { };
      };
    };
    virtualHosts."archlinux-01" = {
      listen = [{ addr = "127.0.0.1"; port = 8010; }];
      locations."/" .proxyPass = "https://mirror.neuf.no/archlinux$request_uri";
    };
    virtualHosts."archlinux-02" = {
      listen = [{ addr = "127.0.0.1"; port = 8011; }];
      locations."/" .proxyPass = "https://mirror.archlinux.no/$request_uri";
    };
  };
}
