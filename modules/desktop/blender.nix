{ user_settings, pkgs, ... }:

{

  users.users.${user_settings.username} = {
    packages = with pkgs; [ unstable.blender ];
  };
}
