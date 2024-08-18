{
  graphics,
  pkgs,
  user,
  ...
}:

let
  blenderPackage = if graphics == "amd" then pkgs.unstable.blender-hip else pkgs.unstable.blender;
in
{

  users.users.${user.username} = {
    packages = [ blenderPackage ];
  };
}
