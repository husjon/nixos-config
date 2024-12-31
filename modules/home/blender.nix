{
  graphics,
  pkgs,
  ...
}:

let
  blenderPackage = if graphics == "amd" then pkgs.stable.blender-hip else pkgs.stable.blender;
in
{
  home.packages = [
    blenderPackage
  ];
}
