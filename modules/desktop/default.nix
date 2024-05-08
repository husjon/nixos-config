{ pkgs, lib, inputs, user_settings, config, ... }:

{
  sops.secrets.password.neededForUsers = true;

  users.mutableUsers = false; # password cannot be changed with `passwd` and will only be set by `hashedPasswordFile` below

  users.users.${user_settings.username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];

    hashedPasswordFile = config.sops.secrets.password.path;

    shell = pkgs.fish;

    packages = with pkgs; [
      alacritty
      discord
      unstable.brave
      freecad
      krita
      prusa-slicer
      git
      grim
      unstable.godot_4
      htop

      libnotify
      lxde.lxsession
      mako

      neovim

      nil
      nixpkgs-fmt

      obsidian
      pcmanfm # file-manager
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
  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
  # Helps during rebuild as `NetworkManager-wait-for-online` fails during rebuilds
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  services.avahi.enable = true; # for Chromecast

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # for Obsidian
  ];

  fonts.packages = [
    pkgs.nerdfonts
  ];

  programs.direnv.enable = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.starship.enable = true;
  programs.fish.enable = true;
  programs.gnupg.agent.enable = true;

  services.printing.enable = true;

  services.syncthing = {
    enable = true;
    user = user_settings.username;
    openDefaultPorts = true;
    dataDir = "/home/" + user_settings.username;
    configDir = "/home/" + user_settings.username + "/.config/syncthing";
  };
  services.tailscale.enable = true;

  xdg.mime.defaultApplications = {
    "inode/directory" = [
      "pcmanfm.desktop"
    ];
  };
}
