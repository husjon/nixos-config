{ ... }:

{
  services.nginx = {
    virtualHosts."cache" = {

      locations."~ ^/debian/(.*?\.deb)$" = {
        extraConfig = ''
          proxy_pass        http://debian/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/debian/(.*?(InRelease|Release|Packages(.gz|.xz)?))$" = {
        extraConfig = ''
          proxy_pass        http://debian/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
      locations."~ ^/debian/(.*?)$" = {
        extraConfig = ''
          proxy_pass        http://debian/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
      locations."~ ^/debian-security/(.*?\.deb)$" = {
        extraConfig = ''
          proxy_pass        http://debian_security/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 4w;
        '';
      };
      locations."~ ^/debian-security/(.*?(InRelease|Release|Packages(.gz|.xz)?))$" = {
        extraConfig = ''
          proxy_pass        http://debian_security/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
      locations."~ ^/debian-security/(.*?)$" = {
        extraConfig = ''
          proxy_pass        http://debian_security/$1;
          proxy_cache       STATIC;
          proxy_cache_valid 200 1h;
        '';
      };
    };

    upstreams."debian" = {
      servers = { "127.0.0.1:8020" = { }; };
    };
    virtualHosts."debian" = {
      listen = [{ addr = "127.0.0.1"; port = 8020; }];
      locations."/" .proxyPass = "http://deb.debian.org/debian$request_uri";
    };

    upstreams."debian_security" = {
      servers = { "127.0.0.1:8021" = { }; };
    };
    virtualHosts."debian_security" = {
      listen = [{ addr = "127.0.0.1"; port = 8021; }];
      locations."/" .proxyPass = "http://security.debian.org/debian-security$request_uri";
    };
  };
}
