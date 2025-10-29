{
  config,
  lib,
  ...
}:
let
  cfg = config.husjon;
in
{
  options.husjon.programs.mako.enable = (lib.mkEnableOption "mako" // { default = true; });

  config = lib.mkIf (cfg.user.enable && cfg.programs.tmux.enable) {
    home-manager.users."${cfg.user.username}" = {
      services = {
        mako = {
          enable = true;

          settings = {
            height = 200;
            width = 500;

            border-radius = 4;
            default-timeout = 2000;
            ignore-timeout = 1;
            anchor = "bottom-right";

            padding = 16;
            margin = "8,0";
            outer-margin = 10;

            layer = "overlay";

            "urgency=high" = {
              default-timeout = 0;
            };

            "app-name=Spotify" = {
              default-timeout = 2000;
              text-color = "#55ce6d";
              border-color = "#55ce6d";
            };

            "app-name=obsidian summary=\"Obsidian Reminder\"" = {
              default-timeout = 0;
              text-color = "#B496F1";
              border-color = "#B496F1";
            };
          };
        };
      };
    };
  };
}
