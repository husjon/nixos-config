{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
in
{
  imports = [
    ./hyprland
    ./sway
  ];

  options.husjon.graphics.window_manager = lib.mkOption {
    description = "Which window manager / wayland compositor to use";
    default = "hyprland";
    type = lib.types.enum [
      "hyprland"
      "sway"
    ];
  };

  config = {
    users.users.${cfg.user.username} = {
      packages = with pkgs; [
        kdePackages.xwaylandvideobridge
      ];
    };

    programs.${cfg.graphics.window_manager} = {
      enable = true;
      xwayland.enable = true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      autoLogin.relogin = true;

      settings = {
        Autologin = {
          Session = "${cfg.graphics.window_manager}.desktop";
          User = cfg.user.username;
        };
      };
    };
  };
}
