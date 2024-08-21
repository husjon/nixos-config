{ pkgs, user_settings, ... }:

{
  users.users.${user_settings.username} = {
    packages = with pkgs; [ krita ];
  };
}
