{ hostname, lib, ... }:
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

  boot.tmp.cleanOnBoot = true;

  services.avahi.enable = true; # for Chromecast
  services.printing.enable = true;
  services.speechd.enable = lib.mkForce false; # speechd is enabled by default

  services.udev.extraRules = builtins.readFile ../../configuration/secrets/${hostname}/99-yubikey.rules;

  documentation.man.generateCaches = true;

  environment.pathsToLink = [ "/share/zsh" ];
}
