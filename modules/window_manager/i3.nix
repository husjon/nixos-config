{ ... }:

{
  services = {
    xserver = {
      enable = true;
      windowManager.i3.enable = true;

      xkb = {
        layout = "no";
        variant = "nodeadkeys";
      };
    };

    displayManager.sddm.enable = true;
  };
}
