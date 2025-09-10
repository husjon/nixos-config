{ hostname, ... }:
{
  services.avahi.enable = true; # for Chromecast
  services.printing.enable = true;

  services.udev.extraRules = builtins.readFile ../../configuration/secrets/${hostname}/99-yubikey.rules;

  documentation.man.generateCaches = true;

  environment.pathsToLink = [ "/share/zsh" ];
}
