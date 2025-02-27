{
  pkgs,
  user,
  ...
}:

{
  users.users.${user.username} = {
    packages = with pkgs; [
      kdePackages.xwaylandvideobridge
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
