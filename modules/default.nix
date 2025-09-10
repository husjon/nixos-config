{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  imports = [ ./user ];

  options.husjon.stateVersion = lib.mkOption {
    description = "The state version to use for the system and home-manager";
    type = lib.types.str;
    example = "24.05";
    default = "24.05";
  };

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";

    home-manager.users = lib.mkIf cfg.user.enable {
      "${cfg.user.username}" = {
        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        home.stateVersion = cfg.stateVersion;
      };
    };
  };
}
