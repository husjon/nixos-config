{ graphics, ... }:
let
  window_manager = if graphics != "nvidia" then ./hyprland.nix else ./i3.nix;
in
{
  imports = [ window_manager ];
}
