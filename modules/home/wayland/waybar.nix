{ user, pkgs, ... }:
let
  catppuccin-waybar = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "ee8ed32b4f63e9c417249c109818dcc05a2e25da";
    hash = "sha256-za0y6hcN2rvN6Xjf31xLRe4PP0YyHu2i454ZPjr+lWA=";
  };
in
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "bottom";
        layer = "bottom";
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
          "format-charging" = "{icon}";

          "format-warning" = "{capacity}% {icon}";
          "format-critical" = "{time} remaining @ {capacity}% {icon}";
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
      @import "${catppuccin-waybar}/themes/mocha.css";

      @define-color background shade(@base, 0.9);
      @define-color foreground @text;

      * {
        margin: 0px;
        padding: 0px;

        font-size: 1.1rem;
      }
      window {
        background-color: @background;
      }
      #waybar {
        padding: 2px;
      }

      #workspaces {
        padding: 1px;
      }

      #workspaces button {
        background-color: @background;
        padding: 0px 6px 0px 4.5px;
        border-radius: 0;
        margin-right: 1px;
        color: @surface2;
      }
      #workspaces button.active {
        color: @foreground;
      }

      #clock, #tray {
        color: @foreground;
        margin: 0 8px;
      }

      #clock > * {
        margin: 0px;
        padding: 0px;
      }

      #tray menu {
        border: 1px solid #524f4f;
        background-color: @background;
        color: @foreground;
        border-radius: 4px;
        padding: 4px;
      }
      #tray menu > * {
        padding: 2px;
      }
      #tray > .needs-attention {
        color: @crust;
        background-color: @red;
      }
    '';
  };
}
