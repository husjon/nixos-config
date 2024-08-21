{ user, pkgs, ... }:

{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";

  imports = [
    ./alacritty.nix
    ./git.nix
    ./neovim.nix
    ./tmux.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    discord
    unstable.brave
    htop

    libnotify
    lxde.lxsession

    networkmanagerapplet

    nerdfonts

    nil
    nixfmt-rfc-style

    obsidian

    pqiv # image viewer

    pavucontrol
    playerctl
    spotify

    trash-cli
    vscode

    xdg-utils
  ];

  programs.direnv.enable = true;
  programs.starship.enable = true;
  programs.fish.enable = true;

  services.syncthing.enable = true;

  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
