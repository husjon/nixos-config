{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;

  shells = [
    pkgs.bash
    pkgs.fish
    pkgs.zsh
  ];
in
{
  imports = [
    ./bash.nix
    ./fish.nix
    ./zsh.nix
  ];

  options.husjon.user = {
    defaultShell = lib.mkOption {
      description = "Which shell should be used as the default shell";
      type = lib.types.enum shells;
      default = pkgs.zsh;
    };
    shells = lib.mkOption {
      description = "Which shells should be enabled for the user";
      type = lib.types.listOf (lib.types.enum shells);

      default = [ cfg.defaultShell ];
    };
  };
}
