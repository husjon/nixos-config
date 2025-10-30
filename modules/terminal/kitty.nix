{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
in
{
  config = lib.mkIf (cfg.user.enable && (cfg.user.terminal == pkgs.kitty)) {
    home-manager.users."${cfg.user.username}" = {
      programs.kitty = {
        enable = true;

        environment = {
          TERM = "xterm-256color";
          EDITOR = "nvim";
        };

        themeFile = "Catppuccin-Mocha";

        settings = {
          enable_audio_bell = false;

          shell = lib.getExe cfg.user.defaultShell;

        };

        keybindings = {
          "ctrl+plus" = "change_font_size all +1.0";
          "ctrl+minus" = "change_font_size all -1.0";
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
