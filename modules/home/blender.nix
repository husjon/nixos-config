{
  graphics,
  pkgs,
  ...
}:

let
  blenderPackage = if graphics == "amd" then pkgs.unstable.blender-hip else pkgs.unstable.blender;
in
{
  home.packages = [
    blenderPackage
  ];
}
