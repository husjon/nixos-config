{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./hypridle.nix
  ];

  config = lib.mkIf (cfg.user.enable && (cfg.graphics.window_manager == "hyprland")) {
    # https://wiki.hyprland.org/Nix/Cachix/
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
