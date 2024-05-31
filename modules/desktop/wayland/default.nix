{ pkgs, user_settings, ... }:

{
  users.users.${user_settings.username} = {
    packages = with pkgs; [
      grim
      mako

      rofi-wayland

      slurp
      waybar
      wl-clipboard
    ];
  };
}
