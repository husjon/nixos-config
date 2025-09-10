{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon;
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

    userId = lib.mkOption {
      description = "The id for the given user";
      type = lib.types.number;
      default = 1000;
    };

    profilePicture = lib.mkOption {
      description = "Path to profile picture used for the user";
      default = null;
      type = lib.types.path;
    };
  };

  config = {
    sops.secrets = {
      password.neededForUsers = true;
    };

    users.groups = {
      ${cfg.user.username} = { };
    };

    users.users.${cfg.user.username} = {
      uid = cfg.user.userId;

      isNormalUser = true;

      group = cfg.user.username;
      extraGroups = [
        cfg.user.username
        "networkmanager"
        "wheel"
      ];

      hashedPasswordFile =
        if config.users.users.${cfg.user.username}.initialPassword != null then
          null
        else
          config.sops.secrets.password.path;
      # initialPassword = "test";  # used when building vm to test
    };

    # adds ~/.local/bin to the users PATH
    environment.localBinInPath = cfg.user.enable;

    home-manager.users = {
      "${cfg.user.username}" = {
        home.username = cfg.user.username;
        home.homeDirectory = "/home/${cfg.user.username}";
        home.file.".face.png".source = cfg.user.profilePicture;

        home.packages = with pkgs; [
          xdg-utils
        ];

        xdg = {
          enable = true;
          userDirs.enable = true;
        };
      };
    };
  };
}
