{
  pkgs,
  user_settings,
  config,
  ...
}:

{
  users.users.${user_settings.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];

    hashedPasswordFile = config.sops.secrets.password.path;

    shell = pkgs.fish;

    packages = with pkgs; [
      alacritty
      discord
      unstable.brave
      git
      git-crypt
      htop

      libnotify
      lxde.lxsession

      neovim

      networkmanagerapplet

      nil
      nixfmt

      obsidian

      pqiv # image viewer

      pavucontrol
      playerctl
      spotify

      tmux
      trash-cli
      vscode

      xdg-user-dirs
      xdg-utils
    ];
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  services.avahi.enable = true; # for Chromecast

  fonts.packages = [ pkgs.nerdfonts ];

  programs.direnv.enable = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.starship.enable = true;
  programs.fish.enable = true;
  programs.gnupg.agent.enable = true;

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.syncthing = {
    enable = true;
    user = user_settings.username;
    openDefaultPorts = true;
    dataDir = "/home/" + user_settings.username;
    configDir = "/home/" + user_settings.username + "/.config/syncthing";
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true; # For persisting changes preferences (since xfce is not used as DM)
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  programs.file-roller.enable = true; # For managing Archives
  services.tumbler.enable = true; # Thumbnail support for images

  xdg.mime.defaultApplications = {
    "inode/directory" = [ "thunar.desktop" ];
  };
}
