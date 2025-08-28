{ ... }:
{
  imports = [
    ./fstrim.nix
    ./nix-store.nix
  ];

  boot.tmp.cleanOnBoot = true;
}
