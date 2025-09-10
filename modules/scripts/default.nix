{ config, lib, ... }:
let
  cfg = config.husjon.user;
in
{
  config = {
    home-manager.users."${cfg.username}" = {
      home.file.".local/bin/" = {
        source = ./bin;
        recursive = true;
        executable = true;
      };
    };
  };
}
