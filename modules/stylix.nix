{ lib, pkgs, ... }:
{

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";

  stylix.fonts = {
    sizes = {
      applications = 12;
      desktop = 12;
      popups = 12;
      terminal = 11;
    };

    emoji = {
      name = "Symbols Nerd Font";
      package = pkgs.nerd-fonts.symbols-only;
    };
    monospace = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.nerd-fonts.fira-mono;
    };
    serif = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    sansSerif = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
  };

  # NixOS options goes here (example: chromium.enable)
  # https://nix-community.github.io/stylix/options/platforms/nixos.html
  stylix.targets = {
  };

  # Home Manager options goes here
  # https://nix-community.github.io/stylix/options/platforms/home_manager.html
  home-manager.sharedModules = lib.singleton {
    stylix.targets = {
      neovim.enable = false;
      waybar.addCss = false;
    };
  };
}
