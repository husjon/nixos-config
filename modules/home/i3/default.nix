{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dunst
    feh

    polybar

    pywal
    rofi

    xss-lock
  ];
}
