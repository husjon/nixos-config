{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;

  gtkTheme = (
    mode: ''
      ${pkgs.dconf}/bin/dconf write \
          /org/gnome/desktop/interface/color-scheme "'prefer-${mode}'"
    ''
  );

  neovim = (mode: ''echo "${mode}" >~/.cache/current-theme'');

in
{
  imports = [
    ./sway.nix
    ./tmux.nix
    ./wallpaper.nix
  ];

  options.husjon.user.services.darkman.enable = (lib.mkEnableOption "darkman" // { default = true; });

  config = lib.mkIf (cfg.user.enable && cfg.user.services.darkman.enable) {
    home-manager.users."${cfg.user.username}" = {
      services.darkman = {
        enable = true;

        darkModeScripts = {
          gtk-theme = gtkTheme "dark";
          neovim = neovim "dark";
        };

        lightModeScripts = {
          gtk-theme = gtkTheme "light";
          neovim = neovim "light";
        };
      };
    };
  };
}
