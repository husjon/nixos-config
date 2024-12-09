{
  config,
  hostname,
  user,
  pkgs,
  ...
}:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";

  imports = [
    ./bash.nix
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./terminal.nix
    ./tmux.nix

    ./scripts

    ./wayland
    ./${hostname}.nix
    ./zsh.nix
  ];

  home.sessionVariables = {
    PATH = "${config.home.homeDirectory}/.local/bin:\$PATH";
    NIL_PATH = "${pkgs.nil}/bin/nil";
  };

  home.file.".face.png".source = user.profile_picture;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    discord
    firefox
    unstable.brave
    htop

    libnotify
    lxde.lxsession

    networkmanagerapplet

    nerd-fonts.fira-code
    nerd-fonts.symbols-only

    nil
    nixfmt-rfc-style

    obsidian

    ripgrep

    pureref

    pqiv # image viewer
    mpv # video player
    zathura # pdf viewer

    pavucontrol
    playerctl
    spotify

    trash-cli
    vscode

    xdg-utils

    yazi
  ];

  home.file.".local/share/icons/default/index.theme" = {
    text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=Bibata-Modern-Ice
    '';
  };

  programs.fzf.enable = true;

  programs.starship.enable = true;

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
