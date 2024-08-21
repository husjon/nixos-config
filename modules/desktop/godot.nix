{ pkgs, user_settings, ... }:

{
  users.users.${user_settings.username} = {
    packages = with pkgs; [ unstable.godot_4 ];
  };
}
