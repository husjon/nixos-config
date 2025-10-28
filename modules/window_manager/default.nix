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

  options.husjon.windowManager.default = lib.mkOption {
    description = "Which window manager / wayland compositor to use";
    default = "hyprland";
    type = lib.types.enum [
      "hyprland"
      "sway"
    ];
  };

  config = lib.mkIf cfg.user.enable {
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

    programs.${cfg.windowManager.default} = {
      enable = true;
      xwayland.enable = true;
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      autoLogin.relogin = true;

      settings = {
        Autologin = {
          Session = "${cfg.windowManager.default}.desktop";
          User = cfg.user.username;
        };
      };
    };
  };
}
