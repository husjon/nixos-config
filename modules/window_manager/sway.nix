{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = {
        output_name = "HDMI-A-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
      };
    };
  };
}
