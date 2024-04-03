{ pkgs, inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.husjon = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      alacritty
      discord
      brave
      freecad
      prusa-slicer
      git
      htop

      libnotify
      lxde.lxsession
      mako

      obsidian
      rofi-wayland
      spotify
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

  services.syncthing = {
    enable = true;
    user = "husjon";
    openDefaultPorts = true;
  };

}
