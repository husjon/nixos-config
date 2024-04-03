{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gamescope
        mangohud
        protontricks
      ];
    };
  };
}
