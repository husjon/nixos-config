{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  imports = [
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
  ];

  config = lib.mkIf (cfg.user.enable && (cfg.graphics.window_manager == "sway")) {
  };
}
