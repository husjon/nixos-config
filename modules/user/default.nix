{
  config,
  lib,
  ...
}:
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

  config = {
    home-manager.users."${config.husjon.user.username}" = { };
  };
}
