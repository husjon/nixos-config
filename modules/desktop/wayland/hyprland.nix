{ pkgs, inputs, user_settings, ... }:

{
  users.users.${user_settings.username} = {
    packages = with pkgs; [
      inputs.hyprcursor.packages."${pkgs.system}".hyprcursor
      inputs.hypridle.packages."${pkgs.system}".hypridle
      inputs.hyprlock.packages."${pkgs.system}".hyprlock
      hyprpaper
      inputs.hyprpicker.packages."${pkgs.system}".hyprpicker
      xdg-desktop-portal-hyprland
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    autoLogin.relogin = true;

    settings = {
      Autologin = {
        Session = "hyprland.desktop";
        User = user_settings.username;
      };
    };
  };
}
