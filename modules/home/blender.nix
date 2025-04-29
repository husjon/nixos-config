{
  graphics,
  pkgs,
  ...
}:

let
  blenderPackage = if graphics == "amd" then pkgs.blender-hip else pkgs.stable.blender;
in
{
  home.packages = [
    blenderPackage
  ];
}
