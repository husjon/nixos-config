{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;

  catppuccin-waybar = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "ee8ed32b4f63e9c417249c109818dcc05a2e25da";
    hash = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA=";
  };
in
{
  options.husjon.programs.waybar.enable = (lib.mkEnableOption "waybar" // { default = true; });

  config = lib.mkIf (cfg.user.enable && cfg.programs.tmux.enable) {
    home-manager.users."${cfg.user.username}" = {
      programs.waybar = {
        enable = true;

        systemd.enable = true;

        settings = {
          mainBar = {
            position = "bottom";
            layer = "bottom";
            margin-left = 10;
            margin-right = 10;
            margin-bottom = 10;

            modules-left = [
              "hyprland/workspaces"
            ];
            modules-center = [
              "hyprland/window"
            ];
            modules-right = [
              "tray"
              "battery"
              "clock"
            ];

            "battery" = {
              "format-icons" = {
                "charging" = [
                  "󰢜"
                  "󰂆"
                  "󰂇"
                  "󰂈"
                  "󰢝"
                  "󰂉"
                  "󰢞"
                  "󰂊"
                  "󰂋"
                  "󰂅"
                ];
                "discharging" = [
                  "󰁺"
                  "󰁻"
                  "󰁼"
                  "󰁽"
                  "󰁾"
                  "󰁿"
                  "󰂀"
                  "󰂁"
                  "󰂂"
                  "󰁹"
                ];
              };

              "format" = "{icon}";

              "format-warning" = "{capacity}% {icon}";
              "format-critical" = "{time} remaining @ {capacity}% {icon}";

              "tooltip-format" = "Empty in {time} ({capacity}%)";
              "tooltip-format-charging" = "Full in {time} ({capacity}%)";

              "states" = {
                "normal" = 50;
                "warning" = 30;
                "critical" = 15;
              };
            };
            "clock" = {
              format-alt = "{:%a, %d. %b  %H:%M}";
            };

            "hyprland/window" = {
              "separate-outputs" = true;
            };
            "hyprland/workspaces" = {
              sort-by = "default";
              format = "{icon}";
              format-icons = {
                "2" = "󰨞"; # nf-md-microsoft_visual_studio_code
                "3" = "󰂫"; # nf-md-blender_software
                "4" = "󱞁"; # nf-md-note_edit
                "5" = "󰓓"; # nf-md-steam
                "6" = "󰈹"; # nf-md-firefox
                "7" = "󰓇"; # nf-md-spotify
                "8" = "󰙯"; # nf-md-discord
              };
            };
          };
        };

        style = ''
          window {
            background-color: @base00;
            border-radius: 4px;
            border: 1px solid @base03;
          }

          #workspaces {
            padding: 1px;
          }

          #workspaces button {
            padding: 0px 6px 0px 4.5px;
            border-radius: 0;
            margin-right: 1px;
          }
          #workspaces button.active {
            background-color: @base02;
            color: @base0D;
          }

          #clock, #tray {
            margin: 0 8px;
          }

          #clock > * {
            margin: 0px;
            padding: 0px;
          }

          #tray menu {
            background-color: @base00;
            border: 1px solid @base03;
            border-radius: 4px;
          }
          #tray menu * {
            border-radius: 2px;
            padding: 2px 0px;
          }
          #tray menu *:hover {
            color: @base0D;
          }
        '';
      };
    };
  };
}
