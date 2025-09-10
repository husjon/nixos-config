{ ... }:
{
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.gnupg.agent.enable = true;
}
