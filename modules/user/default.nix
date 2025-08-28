{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.user;
in
{
  options.husjon.user = {
    enable = lib.mkOption {
      description = "Whether to enable the user";
      default = true;
    };

    username = lib.mkOption {
      type = lib.types.str;
      default = "husjon";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      password.neededForUsers = true;
    };

    users.groups = {
      ${cfg.username} = { };
    };

    users.users.${cfg.username} = {
      isNormalUser = true;

      group = cfg.username;
      extraGroups = [
        cfg.username
        "networkmanager"
        "wheel"
      ];

      hashedPasswordFile =
        if config.users.users.${cfg.username}.initialPassword != null then
          null
        else
          config.sops.secrets.password.path;
      initialPassword = "test"; # used when building vm to test
    };

    home-manager.users = {
      "${cfg.username}" = {
        home.username = cfg.username;
        home.homeDirectory = "/home/${cfg.username}";

        home.packages = with pkgs; [
          kitty
        ];
      };
    };
  };
}
