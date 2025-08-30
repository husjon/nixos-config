{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;

  catppuccin-latte = pkgs.stdenv.mkDerivation (finalAttrs: {
    name = "catppuccin-tmux-latte";

    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/tmux/refs/heads/main/themes/catppuccin_latte_tmux.conf";
      sha256 = "sha256-a8iyOfZGxmLsc84hqKPnS2KEyCClT1bC7jjmN//MVK0=";
    };

    phases = [ "installPhase" ];
    installPhase = "sed 's/set -o/set -/g' $src > $out";
  });

  catppuccin-mocha = pkgs.stdenv.mkDerivation (finalAttrs: {
    name = "catppuccin-tmux-latte";

    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/tmux/refs/heads/main/themes/catppuccin_mocha_tmux.conf";
      sha256 = "sha256-0L7vWV+P04KqP+pHHaCI11YWQsYBZe0rATWVT8t8714=";
    };

    phases = [ "installPhase" ];
    installPhase = "sed 's/set -o/set -/g' $src > $out";
  });

  background = "@thm_crust";
  foreground = "@thm_mauve";
  tms_highlight_background = background;
  tms_highlight_foreground = foreground;
  tms_border_color = foreground;
  tms_info_color = foreground;
  tms_prompt_color = foreground;

  tmux = (
    mode: ''
      function tmux() {
        ${pkgs.tmux}/bin/tmux $@ >/dev/null
      }
      function tms() {
        ${pkgs.tmux-sessionizer}/bin/tms $@ >/dev/null
      }

      tmux source ${if mode == "light" then catppuccin-latte else catppuccin-mocha}


      tmux set -gF status-style "bg=#{${background}},fg=#{${foreground}}"

      highlight_background="$(${pkgs.tmux}/bin/tmux show-options -g ${tms_highlight_background} | ${pkgs.gnugrep}/bin/grep -Eo '#\w+')"
      highlight_foreground="$(${pkgs.tmux}/bin/tmux show-options -g ${tms_highlight_foreground} | ${pkgs.gnugrep}/bin/grep -Eo '#\w+')"
      border_color="$(${pkgs.tmux}/bin/tmux show-options -g ${tms_border_color} | ${pkgs.gnugrep}/bin/grep -Eo '#\w+')"
      info_color="$(${pkgs.tmux}/bin/tmux show-options -g ${tms_info_color} | ${pkgs.gnugrep}/bin/grep -Eo '#\w+')"
      prompt_color="$(${pkgs.tmux}/bin/tmux show-options -g ${tms_prompt_color} | ${pkgs.gnugrep}/bin/grep -Eo '#\w+')"

      tms config --picker-highlight-color "''${highlight_background}"      # Background color of the highlighted item in the picker
      tms config --picker-highlight-text-color "''${highlight_foreground}" # Text color of the hightlighted item in the picker
      tms config --picker-border-color "''${border_color}"                 # Color of the borders between widgets in the picker
      tms config --picker-info-color "''${info_color}"                     # Color of the item count in the picker
      tms config --picker-prompt-color "''${prompt_color}"                 # Color of the prompt in the picker
    ''
  );

in
{
  config = lib.mkIf cfg.programs.tmux.enable {
    home-manager.users."${cfg.username}" = {
      services.darkman = {
        darkModeScripts.tmux = tmux "dark";
        lightModeScripts.tmux = tmux "light";
      };
    };
  };
}
