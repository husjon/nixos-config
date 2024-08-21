{ pkgs, user_settings, ... }:

{
  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    autoLogin.relogin = true;

    settings = {
      Autologin = {
        Session = "sway.desktop";
        User = user_settings.username;
      };
    };
  };
}
