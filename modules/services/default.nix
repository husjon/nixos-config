{ ... }:
{
  imports = [
    ./borgmatic.nix
    ./darkman
    ./docker.nix
    ./mopidy.nix
    ./mpd.nix
    ./syncthing.nix
    ./tailscale
  ];
}
