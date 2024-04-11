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

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "dbus-launch ${pkgs.hyprland}/bin/Hyprland";
        user = user_settings.username;
      };
      default_session = initial_session;
    };
  };
}
