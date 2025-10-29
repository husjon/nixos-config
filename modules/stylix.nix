{ lib, pkgs, ... }:
{

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # NixOS options goes here (example: chromium.enable)
  # https://nix-community.github.io/stylix/options/platforms/nixos.html
  stylix.targets = {
  };

  # Home Manager options goes here
  # https://nix-community.github.io/stylix/options/platforms/home_manager.html
  home-manager.sharedModules = lib.singleton {
    stylix.targets = {
    };
  };
}
