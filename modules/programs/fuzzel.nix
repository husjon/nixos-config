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
            # anchor = "center";
            # dpi-aware = "auto";
            # exit-on-keyboard-focus-loss = " yes";
            fields = "name";
            # filter-desktop = "no";
            # font = "monospace";
            # fuzzy = "yes";
            horizontal-pad = 20;
            # icon-theme = "hicolor";
            # icons-enabled = "yes";
            # image-size-ratio = "0.5";
            # inner-pad = "0";
            # launch-prefix = "<not set>";
            # layer = " top";
            # letter-spacing = "0";
            line-height = 24;
            lines = 8;
            # list-executables-in-path = "no";
            # output = "<not set>";
            # password-character = "*";
            # prompt = "" > "";
            # show-actions = "no";
            # tabs = "8";
            terminal = "${lib.getExe cfg.user.terminal} -";
            vertical-pad = 10;
            width = 40;
          };

          border = {
            width = 2;
            radius = 5;
          };

          dmenu = {
            # mode=text  # text|index
            # exit-immediately-if-empty=no
          };

          key-bindings = {
            # cancel=Escape Control+g
            # cursor-end=End Control+e
            # cursor-home=Home Control+a
            # cursor-left-word=Control+Left Mod1+b
            # cursor-left=Left Control+b
            # cursor-right-word=Control+Right Mod1+f
            # cursor-right=Right Control+f
            # delete-line-backward=Control+u
            # delete-line-forward=Control+k
            # delete-next-word=Mod1+d Control+Delete Control+KP_Delete
            # delete-next=Delete KP_Delete Control+d
            # delete-prev-word=Mod1+BackSpace Control+BackSpace
            # delete-prev=BackSpace
            # execute-input=Shift+Return Shift+KP_Enter
            # execute-or-next=Tab
            # execute=Return KP_Enter Control+y
            next = "Mod1+j";
            # next-page=Page_Down KP_Page_Down
            # next-with-wrap=none
            prev = "Mod1+k";
            # prev-page=Page_Up KP_Page_Up
            # prev-with-wrap=ISO_Left_Tab

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
