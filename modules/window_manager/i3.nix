{ ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
    };

    displayManager.sddm.enable = true;
  };
}
