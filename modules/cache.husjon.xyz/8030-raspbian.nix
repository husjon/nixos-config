{ ... }:

{
  services.nginx = {
    virtualHosts."cache.husjon.xyz" = {

      locations."~ ^/raspbian/(.*?.deb)$" = {
        extraConfig = ''
          proxy_pass        http://raspbian/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/raspbian/(.*?(InRelease|Release|Packages(.gz|.xz)?))$" = {
        extraConfig = ''
          proxy_pass        http://raspbian/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
      locations."~ ^/raspbian/(.*?)$" = {
        extraConfig = ''
          proxy_pass        http://raspbian/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
    };

    upstreams."raspbian" = {
      servers = {
        "127.0.0.1:8030" = { };
      };
    };
    virtualHosts."raspbian" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8030;
        }
      ];
      locations."/".proxyPass = "http://archive.raspberrypi.org/debian$request_uri";
    };
  };
}
