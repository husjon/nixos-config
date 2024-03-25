{ pkgs, inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.husjon = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      firefox
      htop
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
  };

  services.syncthing = {
    enable = true;
    user = "husjon";
    openDefaultPorts = true;
  };

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
