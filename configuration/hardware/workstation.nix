# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0b3e2d64-8116-4f74-bddc-b152aca906cb";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CA59-8077";
    fsType = "vfat";
  };

  fileSystems."/mnt/sda" = {
    device = "/dev/disk/by-uuid/8e513ed9-04ec-4857-bfd8-a49528178c9b";
    fsType = "ext4";
  };

  fileSystems."/mnt/nvme0" = {
    device = "/dev/disk/by-uuid/d7fad3da-7ef5-491d-a345-7c724dc80cd1";
    fsType = "ext4";
  };

  fileSystems."/mnt/nvme2" = {
    device = "/dev/disk/by-uuid/7d534185-18ae-4ac3-b43f-6cbc1903bef5";
    fsType = "ext4";
  };

  fileSystems."/mnt/nvme3" = {
    device = "/dev/disk/by-uuid/d8854e3d-db0e-4f7e-9381-348746378154";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/d1c852ba-884b-42c6-8f7d-756d201484fc"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
