{ ... }:
{
  imports = [
    ./audio.nix

    ./bluetooth.nix

    ./graphics

    ./filemanager.nix
    ./keyring.nix

    ./fstrim.nix
    ./nix-store-maintenance.nix
  ];

  services.avahi.enable = true; # for Chromecast
  services.printing.enable = true;
}
