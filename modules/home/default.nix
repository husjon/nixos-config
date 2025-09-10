{
  hostname,
  ...
}:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml

  imports = [
    ./neovim.nix

    ./scripts

    ./${hostname}.nix
  ];

  home.file.".local/share/icons/default/index.theme" = {
    text = ''
      [Icon Theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=Bibata-Modern-Ice
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
