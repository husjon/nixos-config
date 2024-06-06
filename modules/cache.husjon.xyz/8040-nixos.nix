{ ... }:

{
  nix.settings.substituters = [ "http://127.0.0.1/nixos" ];

  services.nginx = {
    virtualHosts."cache.husjon.xyz" = {

      locations."~ ^/nixos/(.*?)$" = {
        extraConfig = ''
          proxy_pass        http://nixos/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."= /nixos/(nix-cache-info)" = {
        extraConfig = ''
          proxy_pass              http://nixos/$1;
          proxy_cache STATIC;
          proxy_cache_valid  200 302  60d;
          expires max;
          add_header Cache-Control $cache_header always;
        '';
      };
    };

    upstreams."nixos" = {
      servers = { "127.0.0.1:8040" = { }; };
    };
    virtualHosts."nixos" = {
      listen = [{ addr = "127.0.0.1"; port = 8040; }];
      locations."/" .proxyPass = "http://cache.nixos.org$request_uri";
    };
  };
}
