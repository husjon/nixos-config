{ pkgs, ... }:
let
  catppuccin-latte = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/i3/refs/heads/main/themes/catppuccin-latte";
    sha256 = "sha256-akEmLZxEGQ0+3mAFZBX166ySfMZD2OETBQdgTu+SXSs=";
  };

  catppuccin-mocha = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/i3/refs/heads/main/themes/catppuccin-mocha";
    sha256 = "sha256-bzhnsbOPYXV5eUUSJrAIWRpSGx6Phg+10dOlDLHTGeE=";
  };

  sway = (
    mode: ''
      ${pkgs.coreutils}/bin/cat ${
        if mode == "light" then catppuccin-latte else catppuccin-mocha
      } | ${pkgs.findutils}/bin/xargs -L 1 ${pkgs.sway}/bin/swaymsg >/dev/null

      (
        ${pkgs.sway}/bin/swaymsg client.focused '$lavender $base $text $red $lavender'
        ${pkgs.sway}/bin/swaymsg client.focused_inactive '$overlay0 $base $text $rosewater $overlay0'
        ${pkgs.sway}/bin/swaymsg client.unfocused '$overlay0 $base $text $rosewater $overlay0'
        ${pkgs.sway}/bin/swaymsg client.urgent '$peach $base $peach $overlay0 $peach'
        ${pkgs.sway}/bin/swaymsg client.placeholder '$overlay0 $base $text $overlay0 $overlay0'
        ${pkgs.sway}/bin/swaymsg client.background '$base'

        ${pkgs.sway}/bin/swaymsg bar bar-0 colors background '$base'

        ${pkgs.sway}/bin/swaymsg bar bar-0 colors statusline '$text'
        ${pkgs.sway}/bin/swaymsg bar bar-0 colors focused_workspace '$base $mauve $crust'
        ${pkgs.sway}/bin/swaymsg bar bar-0 colors active_workspace '$base $surface2 $text'
        ${pkgs.sway}/bin/swaymsg bar bar-0 colors inactive_workspace '$base $base $text'
        ${pkgs.sway}/bin/swaymsg bar bar-0 colors urgent_workspace '$base $red $crust'
      ) >/dev/null
    ''
  );
in
{
  services.darkman = {
    darkModeScripts.sway = sway "dark";
    lightModeScripts.sway = sway "light";
  };
}
