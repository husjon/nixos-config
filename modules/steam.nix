{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;

    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gamescope
        gamemode
        mangohud
        protontricks
      ];
    };
  };
}
