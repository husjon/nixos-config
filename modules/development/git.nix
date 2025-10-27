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
      ];

      home.file.".local/bin/git-graph" = {
        executable = true;
        text = ''
          ${pkgs.git-graph}/bin/git-graph --color=always | less --use-color
        '';
      };

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
