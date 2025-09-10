{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  config = lib.mkIf cfg.user.enable {
    home-manager.users."${cfg.user.username}" = {
      home.file.".local/bin/" = {
        source = ./bin;
        recursive = true;
        executable = true;
      };
    };
  };
}
