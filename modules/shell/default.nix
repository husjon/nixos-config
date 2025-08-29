{ config, lib, ... }:
let
  cfg = config.husjon.user;

  shells = [
    "bash"
    "fish"
    "zsh"
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
      default = "zsh";
    };
    shells = lib.mkOption {
      description = "Which shells should be enabled for the user";
      type = lib.types.listOf (lib.types.enum shells);

      default = [ cfg.defaultShell ];
    };
  };
}
