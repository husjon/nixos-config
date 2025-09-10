{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  imports = [
    ./hyprland.nix
  ];

  config = lib.mkIf (cfg.graphics.window_manager == "hyprland") {
    # https://wiki.hyprland.org/Nix/Cachix/
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
