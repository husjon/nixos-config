{ ... }:
{
  services = {
    mako = {
      enable = true;

      height = 200;
      width = 500;

      borderRadius = 4;
      defaultTimeout = 5000;
      anchor = "bottom-right";

      backgroundColor = "#181825dd";
      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "#313244";

      extraConfig = ''
        padding=16
        margin=8,0
        outer-margin=10

        [urgency=low]
        border-color=#585b70
        text-color=#a6adc8

        [urgency=high]
        border-color=#f38ba8
        text-color=#f38ba8

        [app-name="Spotify"]
        default-timeout=2000
        text-color=#55ce6d
        border-color=#55ce6d
      '';
    };
  };
}
