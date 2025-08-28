{ config, lib, ... }:
let
  cfg = config.husjon;
in
{
  imports = [
    ./development
    ./syncthing.nix
    ./tailscale
    ./user
  ];

  options.husjon.stateVersion = lib.mkOption {
    description = "The state version to use for the system and home-manager";
    type = lib.types.str;
    example = "24.05";
    default = "24.05";
  };

  config = {
    users.mutableUsers = false; # password cannot be changed with `passwd` and will only be set by `hashedPasswordFile` below

    users.users."root" = {
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFEdno52H8w6cv8J2asTDD3++DZBMZ63UncLznBJWULUAAAABHNzaDo="
      ];
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.users."${cfg.user.username}" = {
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
}
