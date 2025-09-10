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
  options.husjon.programs.neovim.enable = (lib.mkEnableOption "neovim" // { default = true; });

  # TODO: Look into using nixvim
  config = lib.mkIf cfg.programs.neovim.enable {
    home-manager.users."${cfg.user.username}" = {
      programs.neovim = {
        enable = true;

        package = pkgs.unstable.neovim-unwrapped;
      };
    };
  };
}
