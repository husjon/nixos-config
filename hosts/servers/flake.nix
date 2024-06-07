{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs@{ self, nixpkgs, sops-nix, ... }:

    let
      system = "x86_64-linux";

    in
    {
      nixosConfigurations = {
        "cache.husjon.xyz" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./cache.husjon.xyz/configuration.nix
            sops-nix.nixosModules.sops

            ../../modules/cache.husjon.xyz
            ../../modules/cache.husjon.xyz/8000-alpine-linux.nix
            ../../modules/cache.husjon.xyz/8010-archlinux.nix
            ../../modules/cache.husjon.xyz/8020-debian.nix
            ../../modules/cache.husjon.xyz/8030-raspbian.nix
            ../../modules/cache.husjon.xyz/8040-nixos.nix
          ];
        };

        "jellyfin.husjon.xyz" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./jellyfin.husjon.xyz/configuration.nix
            sops-nix.nixosModules.sops

            ../../modules/jellyfin.husjon.xyz
          ];
        };
      };
    };
}