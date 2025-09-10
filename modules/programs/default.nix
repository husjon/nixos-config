{ config, pkgs, ... }:
let
  cfg = config.husjon;
in
{
  imports = [
  ];

  config = {
    home-manager.users."${cfg.user.username}" = {
      home.packages = with pkgs; [
        # TODO: look into cleaning up / moving these packages
        grim
        slurp

        wl-clipboard
      ];
    };
  };
}
