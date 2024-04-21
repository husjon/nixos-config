{ pkgs, inputs, user_settings, config, ... }:

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
      brave
      freecad
      prusa-slicer
      git
      grim
      unstable.godot_4
      htop

      libnotify
      lxde.lxsession
      mako

      neovim

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
