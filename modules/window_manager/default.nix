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

    home-manager.users."${cfg.user.username}" = {
      home.file.".local/share/icons" = {
        source = "${pkgs.bibata-cursors}/share/icons/";
        recursive = true;
      };
      home.file.".local/share/icons/default/index.theme" = {
        text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=Bibata-Modern-Ice
        '';
      };
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
