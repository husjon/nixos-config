{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    environment = {
      TERM = "xterm-256color";
    };

    theme = "Catppuccin-Mocha";

    settings = {
      enable_audio_bell = false;

      shell = "${pkgs.fish}/bin/fish";

    };

    keybindings = {
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
    };
  };
}
