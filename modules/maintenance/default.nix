{ ... }:
{
  imports = [
    ./fstrim.nix
  ];

  boot.tmp.cleanOnBoot = true;
}
