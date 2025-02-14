{
  config,
  pkgs,
  user,
  ...
}:
{
  # 1. initialize with (borg 1.x): sudo borgmatic init --encryption repokey --repository <location_for_backup>
  # 2. back up keys (one or more of):
  #   * `sudo borgmatic key export`
  #   * `sudo borgmatic key export --paper`
  #   * `sudo borgmatic key export --qr-html`

  sops.secrets.borgmatic_passphrase = { };

  services.borgmatic.enable = true;
  services.borgmatic.configurations.user_home = {
    source_directories = [
      "/home/${user.username}"
    ];

    repositories = [
      {
        label = "local";
        path = "/mnt/nvme0/borgmatic/";
      }
    ];

    exclude_caches = true;
    exclude_nodump = true;
    exclude_patterns = [

      # Development
      "/home/*/**/node_modules"
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

      "**/*.log"
    ];

    keep_hourly = 12;
    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 12;

    encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borgmatic_passphrase.path}";
  };
}

# repositories:
#   # - path: ssh://husjon@diskstation420/./borgmatic-testing
#   #   label: nas
#
#   - path: /mnt/nvme0/borgmatic-testing
#     label: nas
