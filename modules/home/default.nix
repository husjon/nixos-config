{
  config,
  hostname,
  user,
  pkgs,
  ...
}:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml

  imports = [
    ./neovim.nix

    ./scripts

    ./${hostname}.nix
  ];

  home.sessionVariables = {
    NIL_PATH = "${pkgs.nil}/bin/nil";
  };

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

  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
