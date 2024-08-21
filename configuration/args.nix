{ ... }:

rec {
  user = {
    username = "husjon";
  };

  laptop = {
    hostname = "laptop";

    graphics = "intel";

    user = user;

    monitors = {
      primary = {
        name = "eDP-1";
        resolution = "2160x1440";
        rate = 60;
        position = "0x0";
        rotation = 0;
      };
    };

    nixSubstituters = [ "https://cache.husjon.xyz/nixos" ];

    stateVersion = "23.11";
  };

  workstation = {
    hostname = "workstation";

    graphics = "amd";

    user = user;

    monitors = {
      primary = {
        name = "DP-1";
        resolution = "2560x1440";
        rate = 144;
        position = "1440x610";
        rotation = 0;
      };
      secondary = {
        name = "DP-2";
        resolution = "2560x1440";
        rate = 144;
        position = "0x0";
        rotation = 90;
      };
      tablet = {
        name = "HDMI-A-1";
        resolution = "1920x1080";
        rate = 60;
        position = "1760x1440";
        rotation = 180;
      };
      tv = {
        name = "DP-3";
        resolution = "1920x1080";
        rate = 60;
      };
    };

    nixSubstituters = [ "https://cache.husjon.xyz/nixos" ];

    stateVersion = "23.11";
  };

  workstation-sb = {
    hostname = "workstation-sb";

    graphics = "nvidia";

    user = user;

    monitors = {
      primary = {
        name = "DP-1";
        resolution = "2560x1440";
        rate = 60;
        position = "0x0";
        rotation = 0;
      };
      secondary = {
        name = "DP-2";
        resolution = "2560x1440";
        rate = 60;
        position = "0x0";
        rotation = 0;
      };
    };

    nixSubstituters = [ ];

    stateVersion = "23.11";
  };
}
