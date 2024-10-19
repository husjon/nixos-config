{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./hibernation.nix
    ./tlp.nix
    ./ups.nix
  ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "github:husjon/nixos-config";
    dates = "04:00";
  };
}
