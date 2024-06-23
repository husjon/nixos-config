{ pkgs, user_settings, ... }:

{
  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "dbus-launch ${pkgs.sway}/bin/sway";
        user = user_settings.username;
      };
      default_session = initial_session;
    };
  };
}
