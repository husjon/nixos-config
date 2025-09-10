{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;
in
{
  config = lib.mkIf (builtins.elem pkgs.bash cfg.shells) {
    home-manager.users."${cfg.username}" = {
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
