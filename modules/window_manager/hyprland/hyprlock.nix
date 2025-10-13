{
  config,
  lib,
  monitors,
  pkgs,
  ...
}:
let
  cfg = config.husjon;

  catppuccin-hyprland = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprland";
    rev = "13d7b4e3db178bb01520eb68e16e4cf4e11da6ab";
    hash = "sha256-jkk021LLjCLpWOaInzO4Klg6UOR4Sh5IcKdUxIn7Dis=";
  };

  homeDirectory = config.home-manager.users.${cfg.user.username}.home.homeDirectory;
in
{
  config = lib.mkIf (cfg.user.enable && (cfg.graphics.window_manager == "hyprland")) {
    home-manager.users."${cfg.user.username}" = {
      programs.hyprlock = {
        enable = true;

        settings = {
          source = "${catppuccin-hyprland}/themes/mocha.conf";

          background = {
            path = "${homeDirectory}/.wallpaper.png";

            # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
            blur_passes = 1; # 0 disables blurring
            blur_size = 3;
            noise = 1.17e-2;
            contrast = 0.9;
            brightness = 0.2;
            vibrancy = 0;
          };

          image = {
            monitor = monitors.primary.name;
            path = "${homeDirectory}/.face.png";
            size = 200;
            border_color = "$overlay0";
            position = "0, 125";
            halign = "center";
            valign = "center";
          };

          input-field = {
            monitor = monitors.primary.name;
            size = "200, 50";

            outline_thickness = 2;
            dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true;
            outer_color = "$overlay0";
            inner_color = "$base";
            font_color = "$text";
            fade_on_empty = true;
            placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
            hide_input = false;

            position = "0, -20";
            halign = "center";
            valign = "center";
          };
        };
      };
    };
  };
}
