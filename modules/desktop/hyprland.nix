{ pkgs, inputs, ... }:

{
  users.users.husjon = {
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
        user = "husjon";
      };
      default_session = initial_session;
    };
  };
}
