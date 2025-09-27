{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.husjon.services.borgmatic;
  username = config.husjon.user.username;
in
{
  # 1. initialize with (borg 1.x): sudo borgmatic init --encryption repokey --repository <location_for_backup>
  # 2. back up keys (one or more of):
  #   * `sudo borgmatic key export`
  #   * `sudo borgmatic key export --paper`
  #   * `sudo borgmatic key export --qr-html`

  options.husjon.services.borgmatic = {
    enable = lib.mkEnableOption "borgmatic";

    extraExcludePatterns = lib.mkOption {
      description = "List of extra path patterns that should be excluded from backup";
      type = lib.listOf (lib.types.str);
      default = [ ];
    };

    repositories = lib.mkOption {
      description = "List of repositories that will be used for storing the backups";

      # type = lib.listOf (lib.types.str);
      # TODO: figure out how to define the type for this
      # listOf attrsets (containing the keys "label" and "path", each with value type of string)
    };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets.borgmatic_passphrase = { };

    services.borgmatic.enable = true;
    services.borgmatic.configurations.user_home = {
      source_directories = [
        "/home/${username}"
      ];

      repositories = cfg.repositories;

      exclude_caches = true;
      exclude_nodump = true;
      exclude_if_present = [
        ".borg-nobackup"
      ];

      exclude_patterns = [

        # Development
        "/home/*/**/node_modules"
        "/home/*/**/.yarn"
        "/home/*/**/target/*"
        "/home/*/.arduino*/packages"
        "/home/*/.arduino*/staging"
        "/home/*/.cargo"
        "/home/*/.docker"
        "/home/*/.local/share/containers"
        "/home/*/.local/share/docker"
        "/home/*/.local/share/godot"
        "/home/*/.local/share/nvim"
        "/home/*/.local/share/pnpm"
        "/home/*/.npm"
        "/home/*/.platformio"
        "/home/*/.rustup/toolchains"

        # Games etc
        "/home/*/.local/share/Steam"
        "/home/*/.local/share/lutris"

        # Other large / unnecessary folders
        "/home/*/**/*t[e]?mp*"
        "/home/*/.*[Cc]ache*"
        "/home/*/.local/share/Trash"
        "/home/*/.local/state"
        "/home/*/.wine"
        "/home/*/Downloads"
        "/home/*/Dropbox"
        "/home/*/Games"
        "/home/*/music"

        "**/*.log"
      ];

      keep_hourly = 12;
      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 12;

      encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borgmatic_passphrase.path}";
    };

    systemd.timers.borgmatic = {
      # not enabled explicitly, it will be picked up automatically when a host has been configured
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "borgmatic.service";
        OnCalendar = "0/4:0"; # run every 4 hours
        Persistent = true;
        RandomizedDelaySec = "15m";
      };
    };
  };
}

# repositories:
#   # - path: ssh://husjon@diskstation420/./borgmatic-testing
#   #   label: nas
#
#   - path: /mnt/nvme0/borgmatic-testing
#     label: nas
