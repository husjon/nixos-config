{ lib, pkgs, ... }:
{
  imports = [ ./kitty.nix ];

  options.husjon.user.terminal = lib.mkOption {
    description = "Which terminal should be used for the user";

    default = pkgs.kitty;
    type = lib.types.enum [
      pkgs.kitty
    ];
  };
}
