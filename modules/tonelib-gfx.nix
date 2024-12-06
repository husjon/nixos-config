{ pkgs, user, ... }:

{
  users.users.${user.username} = {
    packages = [ pkgs.tonelib-gfx ];
  };
}
