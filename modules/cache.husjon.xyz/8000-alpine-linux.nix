{ ... }:

{
  services.nginx = {
    virtualHosts."cache.husjon.xyz" = {
      locations."~ ^/alpine/(.*?.iso(.sig)?)$" = {
        extraConfig = ''
          proxy_pass        http://alpine/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/alpine/(.*?.(apk|tar.gz))$" = {
        extraConfig = ''
          proxy_pass        http://alpine/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/alpine/(.*?.(txt))$" = {
        extraConfig = ''
          proxy_pass        http://alpine/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
    };

    upstreams."alpine" = {
      servers = {
        "127.0.0.1:8000" = { };
      };
    };
    virtualHosts."alpine" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8000;
        }
      ];
      locations."/".proxyPass = "https://mirror.bahnhof.net/pub/alpinelinux$request_uri";
    };
  };
}
