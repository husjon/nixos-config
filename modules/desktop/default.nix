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
      grim
      htop

      libnotify
      lxde.lxsession
      mako

      obsidian
      pcmanfm  # file-manager
      playerctl
      rofi-wayland
      spotify
      slurp
      trash-cli
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

  programs.direnv.enable = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.starship.enable = true;


  services.syncthing = {
    enable = true;
    user = "husjon";
    openDefaultPorts = true;
    dataDir = "/home/husjon";
    configDir = "/home/husjon/.config/syncthing";
  };
  services.tailscale.enable = true;

  xdg.mime.defaultApplications = {
    "inode/directory" = [
      "pcmanfm.desktop"
    ];
  };
}
