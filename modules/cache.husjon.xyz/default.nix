{ ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 ];
  services.nginx = {
    enable = true;

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

    virtualHosts."cache" = {
      listen = [{ addr = "*"; port = 80; }];
    };
  };
}
