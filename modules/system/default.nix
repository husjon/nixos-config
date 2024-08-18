{ ... }:
{
  imports = [
    ./audio.nix
    ./filemanager.nix
    ./keyring.nix
  ];

  services.avahi.enable = true; # for Chromecast
  services.printing.enable = true;
}
