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
  };
}
