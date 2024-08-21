{ pkgs, ... }:

{
  programs = {
    gamemode.enable = true;
    gamescope.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;

      gamescopeSession.enable = true;

      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            mangohud
            protontricks
          ];
      };
    };
  };
}
