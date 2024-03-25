{ pkgs, ... }:

{
  programs.steam.enable = true;

  users.users.husjon = {
    packages = with pkgs; [
      gamescope
      mangohud
      protontricks
    ];
  };
}
