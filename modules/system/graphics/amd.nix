{ ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
}
