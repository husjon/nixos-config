{
  hostname,
  monitors,
  pkgs,
  ...
}:
let
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
          "$mod Shift, F, exec, hyprctl --batch 'dispatch setfloating ; dispatch resizeactive exact 2560 1440 ; dispatch centerwindow'"
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
  imports = [
    ./fuzzel.nix
    ./mako.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp

    wl-clipboard
  ];

  wayland.windowManager.hyprland = with host_specific_config; {
    enable = true;

    settings = {
      source = "~/.config/hypr/colors.conf";

      "$mod" = "SUPER";
      "$terminal" = "${pkgs.alacritty}/bin/alacritty";
      "$menu" = "${pkgs.fuzzel}/bin/fuzzel";

      exec = [
        "hyprctl dispatch dpms on"
        "pkill hypridle; ${pkgs.hypridle}/bin/hypridle"
        "pkill hyprpaper; sleep 0.1; ${pkgs.hyprpaper}/bin/hypridle"
        "pkill waybar; sleep 0.1; ${pkgs.waybar}/bin/waybar"
      ];

      exec-once = [
        #~/bin/pipewire-monitor
        "${pkgs.unstable.brave}/bin/brave"
        "${pkgs.discord}/bin/discord"
        "pkill gnome-keyring; gnome-keyring-daemon"
        "sleep 0.25; loginctl lock-session"
        "${pkgs.spotify}/bin/spotify; playerctl -i brave volume 0.5"
      ];

      env = [
        "QT_QPA_PLATFORMTHEME=qt5ct"
        "GTK_THEME=Adwaita:dark"
        "HYPRCURSOR_THEME,'Bibata-Modern-Ice'"
        "HYPRCURSOR_SIZE,64"
        "XCURSOR_SIZE,64"

        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
      ];

      monitor = monitor;
      workspace = workspace;

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 1;
        "col.active_border" = "$red $green $blue 45deg";
        "col.inactive_border" = "rgba(595959ff)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      misc.force_default_wallpaper = 0;

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes";
        preserve_split = "yes";
        no_gaps_when_only = 1;
      };

      decoration = {
        rounding = 4;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
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
        "$mod Shift, Return, exec, $terminal --command sh -c 'tmux attach || tmux'"
        "$mod Shift, Q, killactive,"
        "$mod Ctrl Shift Alt, Escape, exit,"
        "$mod, S, exec, hyprctl --batch 'dispatch togglefloating ; dispatch centerwindow'"
        "$mod, C, centerwindow"
        "$mod, D, exec, $menu"
        "$mod, P, pseudo, # dwindle"
        "$mod, F, fullscreen"
        "$mod, V, togglesplit"

        "$mod, F12, exec, loginctl lock-session"

        "$mod Shift, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod Ctrl Shift, S, exec, hyprpicker -a"
        "$mod Ctrl Shift, R, exec, hyprctl reload"

        "$mod Ctrl Shift, P, exec, pkill -USR1 waybar"

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
        ", XF86AudioPlay, exec, playerctl -i brave play-pause"
        ", XF86AudioPrev, exec, playerctl -i brave previous"
        ", XF86AudioNext, exec, playerctl -i brave next"
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

      windowrule = [
        "workspace 4 silent, ^(obsidian)(.*)$"
        "workspace 5 silent, class:^(steam)$"
        "workspace 7 silent, ^(Spotify)(.*)$"
        "workspace 8 silent, ^(discord)(.*)$"
      ];
      windowrulev2 = [
        "workspace 5, initialTitle:^(Sign in to Steam)$,title:^(Steam)$" # when running steam with GameScope
        "workspace 5, class:^(gamescope)$"
        "stayfocused, floating:1,class:^(org.freecad.FreeCAD)$"
      ];

    };
  };
}
