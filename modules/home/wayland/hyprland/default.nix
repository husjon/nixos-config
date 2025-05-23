{
  config,
  graphics,
  hostname,
  monitors,
  pkgs,
  ...
}:
let
  catppuccin-hyprland = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprland";
    rev = "13d7b4e3db178bb01520eb68e16e4cf4e11da6ab";
    hash = "sha256-jkk021LLjCLpWOaInzO4Klg6UOR4Sh5IcKdUxIn7Dis=";
  };

  nvidia_env =
    if graphics == "nvidia" then
      [
        "env = LIBVA_DRIVER_NAME,nvidia"
        "env = XDG_SESSION_TYPE,wayland"
        "env = GBM_BACKEND,nvidia-drm"
        "env = __GLX_VENDOR_LIBRARY_NAME,nvidia"
      ]
    else
      [ ];
  host_specific_config =
    with monitors;
    if hostname == "workstation" then
      {
        monitor = [
          "${primary.name}, ${primary.resolution}@${toString primary.rate}, ${primary.position}, 1, transform, ${
            toString (primary.rotation / 90)
          }"
          "${secondary.name}, ${secondary.resolution}@${toString secondary.rate}, ${secondary.position}, 1, transform, ${
            toString (secondary.rotation / 90)
          }"
          "${tablet.name}, ${tablet.resolution}@${toString tablet.rate}, ${tablet.position}, 1, transform, ${
            toString (tablet.rotation / 90)
          }"
          "${tv.name}, ${tv.resolution}@${toString tv.rate}, auto, 1, mirror, ${primary.name}"
        ];

        workspace = [
          "1,  monitor:${primary.name}"
          "2,  monitor:${primary.name}"
          "3,  monitor:${primary.name}"
          "4,  monitor:${primary.name}"
          "5,  monitor:${primary.name}"
          "6,  monitor:${secondary.name}"
          "7,  monitor:${secondary.name}"
          "8,  monitor:${secondary.name}"
          "9,  monitor:${secondary.name}"
          "10, monitor:${secondary.name}"
          "11, monitor:${tablet.name}"
          "12, monitor:${tablet.name}"
        ];

        bind = [
          "$mod Shift, F, exec, hyprctl --batch 'dispatch togglefloating; dispatch setfloating; dispatch resizeactive exact 2560 1440 ; dispatch centerwindow'"
          "$mod Ctrl Shift, F, exec, hyprctl --batch 'keyword monitor ${secondary.name},${secondary.resolution},-200x0,1, transform, 1'"

          "$mod Ctrl Shift Alt, R, exec, hyprctl keyword monitor ${secondary.name},disabled && sleep 0.25 && hyprctl keyword monitor ${tv.name},disabled && sleep 0.5 && hyprctl reload" # Reload monitors
          "$mod, plus, workspace, 11"
          "$mod, backslash, workspace, 12"

          "$mod SHIFT, plus,      movetoworkspacesilent, 11"
          "$mod SHIFT, backslash, movetoworkspacesilent, 12"
        ];
      }
    else if hostname == "laptop" then
      {
        monitor = [
          "${primary.name}, ${primary.resolution}@${toString primary.rate}, ${primary.position}, 1, transform, ${
            toString (primary.rotation / 90)
          }"
        ];

        workspace = [
          "1,  monitor:${primary.name}"
          "2,  monitor:${primary.name}"
          "3,  monitor:${primary.name}"
          "4,  monitor:${primary.name}"
          "5,  monitor:${primary.name}"
          "6,  monitor:${primary.name}"
          "7,  monitor:${primary.name}"
          "8,  monitor:${primary.name}"
          "9,  monitor:${primary.name}"
          "10, monitor:${primary.name}"
        ];

        bind = [ ];
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

  wayland.windowManager.hyprland = with host_specific_config; {
    enable = true;

    settings = {
      source = "${catppuccin-hyprland}/themes/mocha.conf";

      "$mod" = "SUPER";
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      "$menu" = "${pkgs.fuzzel}/bin/fuzzel";

      "$playerctl" = "playerctl -i brave,firefox";

      exec = [
        "hyprctl dispatch dpms on"
        "systemctl --user restart waybar"
        "pgrep -f .Discord-wrapped || ${pkgs.discord}/bin/discord"
        "pgrep -f '^xwaylandvideobridge$' || xwaylandvideobridge"

      ];

      exec-once = [
        #~/bin/pipewire-monitor
        "pkill gnome-keyring; gnome-keyring-daemon"
        "hyprlock"
        "${pkgs.spotify}/bin/spotify; $playerctl volume 0.5"
      ];

      env = [
        "QT_QPA_PLATFORMTHEME=qt5ct"
        "GTK_THEME=Adwaita:dark"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,32"
        "XCURSOR_SIZE,32"

        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "CLUTTER_BACKEND,wayland"
      ] ++ nvidia_env;

      monitor = monitor;
      workspace = [
        # "w[tv1], gapsout:0, gapsin:0, bordersize:0" # emulate smart-gaps
      ] ++ workspace;

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "$red $green $blue 45deg";
        "col.inactive_border" = "$surface2";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      misc.force_default_wallpaper = 0;

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes";
        preserve_split = "yes";
      };

      decoration = {
        rounding = 4;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        # https://wiki.hyprland.org/Configuring/Animations/
        enabled = "yes";

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];

        animation = [
          "windows, 1, 1, default, slidefade"
          "border, 1, 10, default"
          "borderangle, 1, 300, linear, loop"
          "fade, 1, 2, default"
          "workspaces, 1, 5, myBezier, slidefade"
        ];
      };

      input = {
        kb_layout = "no";
        kb_variant = "nodeadkeys";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        repeat_delay = 250;
        repeat_rate = 50;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        scroll_factor = 0.75;
      };

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod Shift, Return, exec, $terminal sh -c 'tmux attach || tmux'"
        "$mod Shift, Q, killactive,"
        "$mod Ctrl Shift Alt, Escape, exit,"
        "$mod, S, exec, hyprctl --batch 'dispatch togglefloating ; dispatch centerwindow'"
        "$mod, C, centerwindow"
        "$mod Shift, C, exec, hyprctl --batch 'dispatch setfloating ; dispatch resizeactive exact 1280 720 ; dispatch centerwindow'"
        "$mod Ctrl Shift, C, exec, hyprctl --batch 'dispatch setfloating ; dispatch resizeactive exact 1920 1080 ; dispatch centerwindow'"

        "$mod, D, exec, $menu"
        "$mod, P, pseudo, # dwindle"
        "$mod, F, fullscreen"
        "$mod, V, togglesplit"

        "$mod, F12, exec, loginctl lock-session"

        "$mod Shift, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod Ctrl Shift, S, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"
        "$mod Ctrl Shift, R, exec, hyprctl reload"

        "$mod Ctrl Alt, P, exec, pkill -USR1 waybar"

        "$mod Ctrl Shift, V, exec, ${pkgs.wtype}/bin/wtype -d 100 -s 250 \"$(${pkgs.wl-clipboard}/bin/wl-paste)\"" # paste from clipboard by typing each character (helpful for certain xwayland apps)

        "$mod Ctrl Shift, h, exec, makoctl restore"
        "Ctrl Shift, Space, exec, makoctl dismiss"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod Shift, h, movewindow, l"
        "$mod Shift, l, movewindow, r"
        "$mod Shift, k, movewindow, u"
        "$mod Shift, j, movewindow, d"

        "$mod Ctrl, h, movecurrentworkspacetomonitor, l"
        "$mod Ctrl, l, movecurrentworkspacetomonitor, r"
        "$mod Ctrl, j, movecurrentworkspacetomonitor, d"
        "$mod Ctrl, k, movecurrentworkspacetomonitor, u"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"
      ] ++ bind;

      binde = [
        "$mod Alt, h, resizeactive, -10 0"
        "$mod Alt, j, resizeactive, 0 10"
        "$mod Alt, k, resizeactive, 0 -10"
        "$mod Alt, l, resizeactive, 10 0"
      ];

      bindl = [
        ",switch:Lid Switch,exec,loginctl lock-session"

        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, $playerctl play-pause"
        ", XF86AudioPrev, exec, $playerctl previous"
        ", XF86AudioNext, exec, $playerctl next"
        #^ comma is required when using without mod key
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        #^ comma is required when using without mod key
      ];

      bindm = [
        "$mod, mouse:272, movewindow" # LMB to move
        "$mod, mouse:273, resizewindow" # MMB to resize
      ];

      windowrulev2 = [
        "bordersize 1, onworkspace:w[tv1], floating:1" # emulate smart-gaps (allow floating windows to retain border"

        "workspace 5, initialTitle:^(Sign in to Steam)$,title:^(Steam)$" # when running steam with GameScope
        "workspace 5, class:^(gamescope)$"
        "stayfocused, floating:1,class:^(org.freecad.FreeCAD)$"

        "idleinhibit focus, class:^(steam_app_.*)" # inhibit hypridle from running when a game run from steam is in focus

        "workspace 4 silent, class:^(obsidian)(.*)$"
        "workspace 5 silent, class:^(steam)$"
        "workspace 7 silent, class:^(Spotify)(.*)$"
        "workspace 8 silent, class:^(discord)(.*)$"

        # Firefox {{{
        "float, class:^(firefox), title:^()$"
        "move 100%-w-12 100%-w-12, class:^(firefox), title:^()$"
        # }}}

        # xwaylandvideobridge {{{
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "float, class:^(xwaylandvideobridge)$"
        # }}}

        # Games {{{
        # Path of Exile {{{
        "tag +poe, class:(steam_app_238960)"
        "float, tag:poe"

        ## Awakened PoE Trade
        "tag +apt, class:(awakened-poe-trade)"
        "float, tag:apt "
        "noblur, tag:apt"
        "nofocus, tag:apt # Disable auto-focus"
        "noshadow, tag:apt"
        "noborder, tag:apt"
        "size 100% 100%, tag:apt"
        "center, tag:apt"
        # }}}
        # }}}

        # Godot {{{
        "tile, class:^(Godot), title:(Godot Engine)$"
        "tag +godot-settings_windows, class:^(Godot), title:(project.godot)"
        "tag +godot-settings_windows, class:^(Godot), title:((Editor|Project) Settings)"
        "tag +godot-settings_windows, class:^(Godot), title:(Create New Node|Change Type of|Dependencies For:|Search Replacement For:)"
        "tag +godot-settings_windows, class:^(Godot), title:(Configure Asset Before Installing)"
        "size 1080 800, tag:godot-settings_windows"
        "center, tag:godot-settings_windows"

        "tag +godot-command_palette, class:^(Godot), title:(Command Palette)"
        "tag +godot-command_palette, class:^(Godot), title:(Search Help)"
        "tag +godot-command_palette, class:^(Godot), title:(Open.*Scene|Quick Open|Save Scene As|Open a File|Select Property)"
        "size 800 600, tag:godot-command_palette"
        "center, tag:godot-command_palette"

        "tag +godot-small_window, class:^(Godot), title:(Load Errors|Select a Node)"
        "size 640 400, tag:godot-small_window"
        "center, tag:godot-small_window"

        "tag +godot-small_vertical_window, class:^(Godot), title:(Pick a node to animate)"
        "size 400 640, tag:godot-small_vertical_window"
        "center, tag:godot-small_vertical_window"
        # }}}
      ];

    };
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      preload = [ "${config.home.homeDirectory}/.wallpaper.png" ];
      wallpaper = [ ", ${config.home.homeDirectory}/.wallpaper.png" ];
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # dbus/sysd lock command (loginctl lock-session)
        ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 630;
          on-timeout = "hyprctl dispatch dpms off";
        }
        {
          timeout = 30;
          on-timeout = "pgrep hyprlock && hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;

    settings = {
      source = "${catppuccin-hyprland}/themes/mocha.conf";

      background = {
        path = "${config.home.homeDirectory}/.wallpaper.png";

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
        path = "${config.home.homeDirectory}/.face.png";
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
}
