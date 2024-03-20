{ pkgs, inputs, ... }:

{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "husjon";
      };
      default_session = initial_session;
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.hypridle.packages."${pkgs.system}".hypridle
    inputs.hyprlock.packages."${pkgs.system}".hyprlock
  ];

}
