{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  husjon.graphics.manufacturer = "amd";
  husjon.programs.blender.enable = true;
  husjon.programs.extraPrograms = with pkgs; [
    calibre
    freecad
    godot_4
    krita
    lutris
    prusa-slicer
    tonelib-gfx
    stable.vcv-rack
  ];
  husjon.programs.rmpc.enable = true;
  husjon.programs.steam.enable = true;
  husjon.services.borgmatic.enable = true;
  husjon.services.borgmatic.repositories = [
    {
      label = "local";
      path = "/mnt/nvme0/borgmatic/";
    }
  ];
  husjon.services.docker.enable = true;
  husjon.services.mpd.enable = true;
  husjon.services.tailscale.exitNode = true;
  husjon.system.kernel = "latest";
  husjon.system.ups.enable = true;

  networking.interfaces."eno1".wakeOnLan.enable = true;

  husjon.stateVersion = "25.05";
}
