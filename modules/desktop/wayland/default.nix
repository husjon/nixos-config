{ pkgs, user_settings, ... }:

{
  users.users.${user_settings.username} = {
    packages = with pkgs; [
      fuzzel

      grim
      mako

      slurp
      waybar
      wl-clipboard
    ];
  };
}
