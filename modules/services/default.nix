{ ... }:
{
  imports = [
    ./borgmatic.nix
    ./darkman
    ./docker.nix
    ./mopidy.nix
    ./syncthing.nix
    ./tailscale
  ];
}
