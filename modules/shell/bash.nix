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
  config = lib.mkIf (cfg.user.enable && (builtins.elem pkgs.bash cfg.user.shells)) {
    home-manager.users."${cfg.user.username}" = {
      programs.bash = {
        enable = true;

        historyControl = [ "ignoreboth" ];

        profileExtra = ''
          eval "$(direnv hook bash)"
        '';
      };
    };
  };
}
