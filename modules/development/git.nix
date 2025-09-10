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
  home-manager.users = lib.mkIf cfg.user.enable {
    "${cfg.user.username}" = {
      home.packages = with pkgs; [
        git-crypt
        git-graph
      ];

      programs.gh.enable = true;
      programs.git = {
        enable = true;

        extraConfig = {
          core.excludesfile = "~/.gitignore";
        };
      };

      home.file.".gitignore" = {
        text = ''
          .borg-nobackup
        '';
      };

      programs.lazygit.enable = true;
    };
  };
}
