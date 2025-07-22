{ ... }:
{
  services = {
    mako = {
      enable = true;

      settings = {
        height = 200;
        width = 500;

        border-radius = 4;
        default-timeout = 2000;
        ignore-timeout = 1;
        anchor = "bottom-right";

        background-color = "#181825dd";
        text-color = "#cdd6f4";
        border-color = "#89b4fa";
        progress-color = "#313244";

        padding = 16;
        margin = "8,0";
        outer-margin = 10;

        layer = "overlay";

        "urgency=low" = {
          border-color = "#585b70";
          text-color = "#a6adc8";
        };

        "urgency=high" = {
          border-color = "#f38ba8";
          text-color = "#f38ba8";
          default-timeout = 0;
        };

        "app-name=Spotify" = {
          default-timeout = 2000;
          text-color = "#55ce6d";
          border-color = "#55ce6d";
        };

        "app-name=obsidian summary=\"Obsidian Reminder\"" = {
          default-timeout = 0;
          text-color = "#B496F1";
          border-color = "#B496F1";
        };
      };
    };
  };
}
