{ pkgs, ... }:
{
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true; # For persisting changes preferences (since xfce is not used as DM)
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  programs.file-roller.enable = true; # For managing Archives
  services.tumbler.enable = true; # Thumbnail support for images

  xdg.mime.defaultApplications = {
    "inode/directory" = [ "thunar.desktop" ];
  };
}
