{ lib, ... }:
{
  imports = [
    ./amd.nix
    ./intel.nix
    ./nvidia.nix
  ];

  options.husjon.graphics.manufacturer = lib.mkOption {
    description = "Which kind of graphics card manufacturer is used in the system";
    type = lib.types.enum [
      "amd"
      "intel"
      "nvidia"
    ];
    example = "amd";
  };

  config = {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
