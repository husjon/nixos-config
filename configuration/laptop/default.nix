{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  husjon.graphics.manufacturer = "intel";
  husjon.system.tlp.enable = true;
  husjon.system.hibernation.enable = true;
  services.fprintd.enable = true;

  husjon.stateVersion = "24.11";
}
