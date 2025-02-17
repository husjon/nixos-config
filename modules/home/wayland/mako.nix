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

      backgroundColor = "#1e1e2e";
      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "#313244";

      extraConfig = ''
        padding=16
        margin=8,0
        outer-margin=10

        [urgency=high]
        border-color=#fab387

        [app-name="Spotify"]
        default-timeout=2000
        background-color=#1ED760
        text-color=#1e1e2e
        border-color=#09682a
      '';
    };
  };
}
