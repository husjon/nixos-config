{ pkgs, user_settings, ... }:

{
  services = {
    xserver = {
      enable = true;
    };

    displayManager.sddm.enable = true;
  };

  users.users.${user_settings.username} = {
    packages = with pkgs; [
      dunst
      feh

      polybar
      pywal
      rofi

      xss-lock
    ];
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec { polybar = pkgs.polybar.override { i3Support = true; }; };
  };
}
