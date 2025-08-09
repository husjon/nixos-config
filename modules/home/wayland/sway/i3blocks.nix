{ lib, pkgs, ... }:
let
  toggleDarkmode = pkgs.writeScriptBin "toggle" ''
    CURRENT_MODE=$(${pkgs.darkman}/bin/darkman get)
    ICON_LIGHT=󰌵 # nf-md-lightbulb
    ICON_DARK=󰌶  # nf-md-lightbulb_outline

    case "''${CURRENT_MODE}" in
    "dark")
      CURRENT_ICON=''${ICON_DARK}
      NEXT_ICON=''${ICON_LIGHT}
      ;;
    "light")
      CURRENT_ICON=''${ICON_LIGHT}
      NEXT_ICON=''${ICON_DARK}
      ;;
    *)
      echo 󱧡  # there were an error
      ;;
    esac

    if [[ ! -z "''${BLOCK_BUTTON}" ]]; then
      ${pkgs.darkman}/bin/darkman toggle >/dev/null
      echo ''${NEXT_ICON}
    else
      echo ''${CURRENT_ICON}
    fi
  '';

in
{
  programs.i3blocks = {
    # https://vivien.github.io/i3blocks
    enable = true;

    bars.config = {
      toggle_darkmode = lib.hm.dag.entryBefore [ "time" ] {
        color = "#f5af19";
        command = "${toggleDarkmode}/bin/toggle";
        interval = "once";
        align = "center";
      };

      time = {
        command = "date '+%Y-%m-%d %H:%M'";
        interval = "5";
      };
    };
  };
}
