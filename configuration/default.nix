{
  pkgs,
  user,
  hostname,
  stateVersion,
  config,
  ...
}:

{
  imports = [
    ./hardware/${hostname}.nix
    ./graphics

    ./fstrim.nix
    ./nix-store-maintenance.nix
  ];

  sops.defaultSopsFile = ./secrets/${hostname}.sops.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

  users.users."root" = {
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFEdno52H8w6cv8J2asTDD3++DZBMZ63UncLznBJWULUAAAABHNzaDo="
    ];
  };

  sops.secrets.password.neededForUsers = true;
  users.mutableUsers = false; # password cannot be changed with `passwd` and will only be set by `hashedPasswordFile` below
  users.users.${user.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    hashedPasswordFile = config.sops.secrets.password.path;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.substituters = [ "https://cache.husjon.xyz/nixos" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = stateVersion;
}
