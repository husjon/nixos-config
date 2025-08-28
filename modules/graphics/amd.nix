{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
in
{
  config = lib.mkIf (cfg.graphics.manufacturer == "amd") {
    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.amdgpu.opencl.enable = true;

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

  };
}
