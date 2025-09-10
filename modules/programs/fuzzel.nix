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
  options.husjon.programs.fuzzel.enable = (lib.mkEnableOption "fuzzel" // { default = true; });

  config = lib.mkIf (cfg.user.enable && cfg.programs.tmux.enable) {
    home-manager.users."${cfg.user.username}" = {
      programs.fuzzel = {
        enable = true;

        settings = {
          main = {
            ##
            # output=<not set>
            # font=monospace
            # dpi-aware=auto
            # prompt="> "
            # icon-theme=hicolor
            # icons-enabled=yes
            # fields=filename,name,generic
            # password-character=*
            # filter-desktop=no
            # fuzzy=yes
            # show-actions=no
            # terminal=$TERMINAL -e  # Note: you cannot actually use environment variables here

            # TODO: update terminal to point to configured terminal
            terminal = "${pkgs.kitty}/bin/kitty -";
            # launch-prefix=<not set>
            # list-executables-in-path=no

            # anchor=center
            # lines=15
            lines = 8;
            # width=30
            width = 40;
            # tabs=8
            # horizontal-pad=40
            horizontal-pad = 20;
            # vertical-pad=8
            vertical-pad = 10;
            # inner-pad=0

            # image-size-ratio=0.5

            # line-height=<use font metrics>
            line-height = 24;
            # letter-spacing=0

            # layer = top
            # exit-on-keyboard-focus-loss = yes
          };

          colors = {
            background = "1e1e2eee";
            text = "cdd6f4ff";
            match = "f38ba8ff";
            selection = "585b70ff";
            selection-match = "f38ba8ff";
            selection-text = "cdd6f4ff";
            border = "b4befeff";
          };

          border = {
            # width=1
            width = 2;
            # radius=10
            radius = 5;
          };

          dmenu = {
            # mode=text  # text|index
            # exit-immediately-if-empty=no
          };

          key-bindings = {
            # cancel=Escape Control+g
            # execute=Return KP_Enter Control+y
            # execute-or-next=Tab
            # execute-input=Shift+Return Shift+KP_Enter
            # cursor-left=Left Control+b
            # cursor-left-word=Control+Left Mod1+b
            # cursor-right=Right Control+f
            # cursor-right-word=Control+Right Mod1+f
            # cursor-home=Home Control+a
            # cursor-end=End Control+e
            # delete-prev=BackSpace
            # delete-prev-word=Mod1+BackSpace Control+BackSpace
            # delete-line-backward=Control+u
            # delete-next=Delete KP_Delete Control+d
            # delete-next-word=Mod1+d Control+Delete Control+KP_Delete
            # delete-line-forward=Control+k
            # prev=Up Control+p
            prev = "Mod1+k";
            # prev-with-wrap=ISO_Left_Tab
            # prev-page=Page_Up KP_Page_Up
            # next=Down Control+n
            next = "Mod1+j";
            # next-with-wrap=none
            # next-page=Page_Down KP_Page_Down

            # custom-N: *dmenu mode only*. Like execute, but with a non-zero
            # exit-code; custom-1 exits with code 10, custom-2 with 11, custom-3
            # with 12, and so on.

            # custom-1=Mod1+1
            # custom-2=Mod1+2
            # custom-3=Mod1+3
            # custom-4=Mod1+4
            # custom-5=Mod1+5
            # custom-6=Mod1+6
            # custom-7=Mod1+7
            # custom-8=Mod1+8
            # custom-9=Mod1+9
            # custom-10=Mod1+0
            # custom-11=Mod1+exclam
            # custom-12=Mod1+at
            # custom-13=Mod1+numbersign
            # custom-14=Mod1+dollar
            # custom-15=Mod1+percent
            # custom-16=Mod1+dead_circumflex
            # custom-17=Mod1+ampersand
            # custom-18=Mod1+asterix
            # custom-19=Mod1+parentleft
            ##
          };
        };
      };
    };
  };
}
