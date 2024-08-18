{ pkgs, user, ... }:

{
  users.users.${user.username} = {
    packages = with pkgs; [ unstable.godot_4 ];
  };
}
