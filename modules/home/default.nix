{
  hostname,
  ...
}:
{
  # List of options: https://nix-community.github.io/home-manager/options.xhtml

  imports = [
    ./neovim.nix

    ./${hostname}.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
