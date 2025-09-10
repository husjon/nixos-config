{ ... }:
{
  imports = [
    ./fstrim.nix
    ./home-manager.nix
    ./nix-store.nix
  ];

  boot.tmp.cleanOnBoot = true;
}
