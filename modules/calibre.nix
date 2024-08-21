{ pkgs, user, ... }:

{
  users.users.${user.username} = {
    packages = with pkgs; [ calibre ];
  };
}