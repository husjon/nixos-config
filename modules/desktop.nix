{ pkgs, inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.husjon = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      discord
      firefox
      git
      htop

      inputs.hypridle.packages."${pkgs.system}".hypridle
      inputs.hyprlock.packages."${pkgs.system}".hyprlock
      hyprpaper

      libnotify
      lxde.lxsession
      mako

      obsidian
      rofi-wayland
      vscode
      waybar
      wl-clipboard

      xdg-user-dirs
      xdg-utils
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"  # for Obsidian
  ];

  fonts.packages = [
    pkgs.nerdfonts
  ];

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

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
}
