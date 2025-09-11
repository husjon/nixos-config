{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.husjon;

in
{
  imports = [ ./hardware/${hostname}.nix ];

  options.husjon.system.kernel = lib.mkOption {
    description = "Which kernel to use";
    default = "stable";
    type = lib.types.enum [
      "stable"
      "latest"
    ];
  };
  options.husjon.system.nix.substituters = lib.mkOption {
    description = "List of URLs to use as substituters";

    default = [
      "https://cache.husjon.xyz/nixos"
    ];
  };

  config = {
    sops.defaultSopsFile = ./secrets/${hostname}.sops.yaml;
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    # This will generate a new key if the key specified above does not exist
    sops.age.generateKey = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.settings.substituters = cfg.system.nix.substituters;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];

    boot.kernelPackages =
      if (config.husjon.system.kernel == "latest") then pkgs.linuxPackages_latest else pkgs.linuxPackages;

    # Set your time zone.
    time.timeZone = "Europe/Oslo";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };

    # Configure console keymap
    console.keyMap = "no";

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    environment.systemPackages = with pkgs; [ vim ];

    # Enable networking
    networking.networkmanager.enable = true;

    networking.hostName = hostname; # Define your hostname.

    # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
    # Helps during rebuild as `NetworkManager-wait-for-online` fails during rebuilds
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.avahi.enable = true; # for Chromecast
    services.printing.enable = true;

    services.udev.extraRules = builtins.readFile ./secrets/${hostname}/99-yubikey.rules;

    documentation.man.generateCaches = true;

    system.stateVersion = config.husjon.stateVersion;

    programs.command-not-found.enable = true;

    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation.memorySize = 8 * 1024;
      virtualisation.cores = 4;
    };
  };
}
