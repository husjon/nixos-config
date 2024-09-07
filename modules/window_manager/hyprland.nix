{
  pkgs,
  inputs,
  user,
  ...
}:

{
  users.users.${user.username} = {
    packages = with pkgs; [
      inputs.hyprcursor.packages."${pkgs.system}".hyprcursor
      xdg-desktop-portal-hyprland
    ];
  };

  # https://wiki.hyprland.org/Nix/Cachix/
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    autoLogin.relogin = true;

    settings = {
      Autologin = {
        Session = "hyprland.desktop";
        User = user.username;
      };
    };
  };
}
