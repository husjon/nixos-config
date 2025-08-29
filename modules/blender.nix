{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.husjon;
  graphicsManufacturer = cfg.graphics.manufacturer;
in
{
  options.husjon.programs.blender.enable = lib.mkEnableOption "blender";

  config = lib.mkIf cfg.programs.blender.enable {
    users.users."${cfg.user.username}".packages = [
      (if graphicsManufacturer == "amd" then pkgs.blender-hip else pkgs.blender)
    ];
  };
}
