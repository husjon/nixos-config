{
  config,
  hostname,
  monitors,
  pkgs,
  ...
}:
let
  catppuccin-i3 = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "i3";
    rev = "c072ada05271eec960dc893affe9ac55af63a745";
    hash = "sha256-H+ZueiYkCoBfS8JENLKhL/efFK6WFNDsbiMbTpGROUs=";
  };

  host_specific_config =
    with monitors;
    if hostname == "workstation" then
      {
        output = {
          ${primary.name} = {
            mode = "${primary.resolution}@${toString primary.rate}Hz";
            pos = "${builtins.replaceStrings [ "x" ] [ " " ] primary.position}";
            transform = "${toString primary.rotation}";
          };
          ${secondary.name} = {
            mode = "${secondary.resolution}@${toString secondary.rate}Hz";
            pos = "${builtins.replaceStrings [ "x" ] [ " " ] secondary.position}";
            transform = "${toString secondary.rotation}";
          };
          ${tablet.name} = {
            mode = "${tablet.resolution}@${toString tablet.rate}Hz";
            pos = "${builtins.replaceStrings [ "x" ] [ " " ] tablet.position}";
            transform = "${toString tablet.rotation}";
          };
        };

        workspaceOutputAssign = [
          {
            workspace = "1";
            output = primary.name;
          }
          {
            workspace = "2";
            output = primary.name;
          }
          {
            workspace = "3";
            output = primary.name;
          }
          {
            workspace = "4";
            output = primary.name;
          }
          {
            workspace = "5";
            output = primary.name;
          }
          {
            workspace = "6";
            output = secondary.name;
          }
          {
            workspace = "7";
            output = secondary.name;
          }
          {
            workspace = "8";
            output = secondary.name;
          }
          {
            workspace = "9";
            output = secondary.name;
          }
          {
            workspace = "10";
            output = secondary.name;
          }
          {
            workspace = "11";
            output = tablet.name;
          }
          {
            workspace = "12";
            output = tablet.name;
          }
        ];
      }
    else if hostname == "laptop" then
      {
        output = {
          ${primary.name} = {
            mode = "${primary.resolution}@${toString primary.rate}Hz";
            pos = "${builtins.replaceStrings [ "x" ] [ " " ] primary.position}";
            transform = "${toString primary.rotation}";
            scale = "1.2";
          };
        };

        workspaceOutputAssign = [
          {
            workspace = "1";
            output = primary.name;
          }
          {
            workspace = "2";
            output = primary.name;
          }
          {
            workspace = "3";
            output = primary.name;
          }
          {
            workspace = "4";
            output = primary.name;
          }
          {
            workspace = "5";
            output = primary.name;
          }
          {
            workspace = "6";
            output = primary.name;
          }
          {
            workspace = "7";
            output = primary.name;
          }
          {
            workspace = "8";
            output = primary.name;
          }
          {
            workspace = "9";
            output = primary.name;
          }
          {
            workspace = "10";
            output = primary.name;
          }
        ];
      }
    else
      { };
in
{
  home.file.".local/share/icons" = {
    source = "${pkgs.bibata-cursors}/share/icons/";
    recursive = true;
  };

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  wayland.windowManager.sway = with host_specific_config; {
    enable = true;

    extraConfigEarly = ''
      include ${catppuccin-i3}/themes/catppuccin-mocha
    '';

    config = {
      modifier = "Mod4";

      output = output;

      workspaceOutputAssign = [ ] ++ workspaceOutputAssign;

      startup = [
        { command = "${pkgs.swaylock}/bin/swaylock"; }
        {
          command = "swaymsg output '*' bg ~/.wallpaper.png fill";
          always = true;
        }
        {
          command = "pkill swayidle; ${pkgs.swayidle}/bin/swayidle";
          always = true;
        }
      ];

      gaps = {
        inner = 12;
        outer = 0;
        smartBorders = "on";
        smartGaps = true;
      };
      window = {
        border = 1;
        titlebar = false;

        commands = [
          {
            command = "inhibit_idle focus";
            criteria = {
              class = "steam_app*";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              class = ".*";
            };
          }
        ];
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "no";
          xkb_variant = "nodeadkeys";
          repeat_delay = "250";
          repeat_rate = "50";
        };
      };

      assigns = {
        "3" = [ { app_id = "blender"; } ];
        "4" = [ { class = "obsidian"; } ];
        "5" = [ { class = "steam"; } ];
        "7" = [ { class = "[Ss]potify"; } ];
        "8" = [ { class = "[Dd]iscord"; } ];
      };

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
          terminal = "${pkgs.kitty}/bin/kitty";
        in
        {
          "${modifier}+Ctrl+Shift+R" = "reload";
          "${modifier}+Shift+Ctrl+Alt+Escape " = "exit";
          "${modifier}+Shift+Q" = "kill";

          "${modifier}+F12" = "exec loginctl lock-session";

          "${modifier}+D" = "exec ${pkgs.fuzzel}/bin/fuzzel";
          "${modifier}+Shift+S" =
            "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
          "${modifier}+Ctrl+Shift+S" =
            "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -o)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+Return" = "exec ${terminal} --hold sh -c 'tmux a || tmux '";

          "${modifier}+Ctrl+Shift+H" = "exec makoctl restore";
          "${modifier}+Ctrl+Shift+Period" = "exec makoctl invoke";
          "${modifier}+Ctrl+Space" = "exec makoctl dismiss";

          "${modifier}+F" = "fullscreen";
          "${modifier}+Shift+F" = "exec bash -c '${
            toString [
              "swaymsg floating enable;"
              "swaymsg resize set 2560 1440;"
              "swaymsg move position center;"
              "swaymsg move down 12;"
            ]
          }'";
          "${modifier}+C" = "exec bash -c 'swaymsg floating enable; swaymsg move position center'";
          "${modifier}+Shift+C" = "exec bash -c '${
            toString [
              "floating enable;"
              "swaymsg resize set width 1280 px height 720 px;"
              "swaymsg move position center"
            ]
          }'";
          "${modifier}+Ctrl+Shift+C" = "exec bash -c '${
            toString [
              "floating enable;"
              "swaymsg resize set width 1920 px height 1080 px;"
              "swaymsg move position center"
            ]
          }'";
          "${modifier}+S" = "floating toggle; swaymsg move position center";
          "${modifier}+V" = "split toggle";

          "${modifier}+H" = "focus left";
          "${modifier}+J" = "focus down";
          "${modifier}+K" = "focus up";
          "${modifier}+L" = "focus right";
          "${modifier}+Shift+H" = "move left";
          "${modifier}+Shift+J" = "move down";
          "${modifier}+Shift+K" = "move up";
          "${modifier}+Shift+L" = "move right";
          "${modifier}+Ctrl+H" = "move workspace to output left";
          "${modifier}+Ctrl+J" = "move workspace to output down";
          "${modifier}+Ctrl+K" = "move workspace to output up";
          "${modifier}+Ctrl+L" = "move workspace to output right";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Plus" = "workspace number 11";
          "${modifier}+Backslash" = "workspace number 12";
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          "${modifier}+Shift+Plus" = "move container to workspace number 11";
          "${modifier}+Shift+Backslash" = "move container to workspace number 12";

          XF86AudioPrev = "exec playerctl -i 'brave,firefox' previous";
          XF86AudioPlay = "exec playerctl -i 'brave,firefox' play-pause";
          XF86AudioNext = "exec playerctl -i 'brave,firefox' next";
          XF86AudioMute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          XF86AudioLowerVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          XF86AudioRaiseVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        };

      colors = {
        background = "$base";
        focused = {
          childBorder = "$lavender";
          background = "$base";
          text = "$text";
          indicator = "$red";
          border = "$lavender";
        };
        focusedInactive = {
          childBorder = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$rosewater";
          border = "$overlay0";
        };
        unfocused = {
          childBorder = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$rosewater";
          border = "$overlay0";
        };
        urgent = {
          childBorder = "$peach";
          background = "$base";
          text = "$peach";
          indicator = "$overlay0";
          border = "$peach";
        };
        placeholder = {
          childBorder = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$overlay0";
          border = "$overlay0";
        };
      };

      bars = [
        {
          position = "bottom";

          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";

          extraConfig = ''
            font pango:FiraCode Nerd Font 10
            height 0
            workspace_min_width 24

            strip_workspace_name yes
            strip_workspace_numbers no
          '';

          colors = {
            statusline = "$text";
            background = "$base";

            focusedWorkspace = {
              border = "$base";
              background = "$mauve";
              text = "$crust";
            };
            activeWorkspace = {
              border = "$base";
              background = "$surface2";
              text = "$text";
            };
            inactiveWorkspace = {
              border = "$base";
              background = "$base";
              text = "$text";
            };
            urgentWorkspace = {
              border = "$base";
              background = "$red";
              text = "$crust";
            };
          };
        }
      ];
    };
  };

  imports = [ ./i3blocks.nix ];
}
