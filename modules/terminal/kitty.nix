{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;
in
{
  config = lib.mkIf (cfg.terminal == "kitty") {
    home-manager.users."${cfg.username}" = {
      programs.kitty = {
        enable = true;

        environment = {
          TERM = "xterm-256color";
          EDITOR = "nvim";
        };

        themeFile = "Catppuccin-Mocha";

        settings = {
          enable_audio_bell = false;

          #TODO: move shell references to separate option
          shell = "${pkgs.zsh}/bin/zsh";

        };

        keybindings = {
          "ctrl+plus" = "change_font_size all +2.0";
          "ctrl+minus" = "change_font_size all -2.0";
          "ctrl+0" = "change_font_size all 0";
        };

        extraConfig = ''
          # disable left_click and shift+left_click for links
          mouse_map left click ungrabbed
          mouse_map shift+left click ungrabbed
          # use ctrl+left_click for links
          mouse_map ctrl+left release grabbed,ungrabbed mouse_handle_click link
        '';

      };
    };
  };
}
