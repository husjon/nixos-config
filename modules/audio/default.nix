{ lib, hostname, ... }:
{
  # Conditionally import audio configuration for the specified hostname
  imports = lib.optional (builtins.pathExists ./${hostname}.nix) ./${hostname}.nix;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    wireplumber.enable = true;
  };
}
