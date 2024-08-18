{ graphics, ... }:
let
  graphics_configuration =
    if graphics == "amd" then
      ./amd.nix
    else if graphics == "intel" then
      ./intel.nix
    else if graphics == "nvidia" then
      ./nvidia.nix
    else
      ./fail.nix;
in
{
  imports = [ graphics_configuration ];
}
