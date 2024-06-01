{ pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = [ "intel" ];

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
}
