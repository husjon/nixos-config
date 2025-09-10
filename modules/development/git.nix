{ config, pkgs, ... }:
let
  cfg = config.husjon.user;
in
{
  home-manager.users."${cfg.username}" = {
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
}
