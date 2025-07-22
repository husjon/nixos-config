{
  description = "NixOS flake for husjon";

  inputs = {
    # Nix channel status: https://status.nixos.org/
    # https://discourse.nixos.org/t/differences-between-nix-channels/13998
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-unstable,
      sops-nix,
      home-manager,
      ...
    }:

    let
      system = "x86_64-linux";

      overlays-nixpkgs = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      configuration = import ./configuration/args.nix { inherit inputs; };

      commonModules = [
        ./configuration
        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users."${configuration.user.username}" = import ./modules/home;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
        ({ nixpkgs.overlays = [ overlays-nixpkgs ]; })

        ./modules/system

        ./modules/window_manager

        ./modules/tailscale
      ];

    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = configuration.laptop // {
            inherit inputs;
          };

          modules = commonModules ++ [
            { home-manager.extraSpecialArgs = configuration.laptop; }
            ./modules/system/tlp.nix
          ];
        };

        workstation = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = configuration.workstation // {
            inherit inputs;
          };

          modules = commonModules ++ [
            (
              { pkgs, ... }:
              {
                boot.kernelPackages = pkgs.linuxPackages_latest;
              }
            )

            { home-manager.extraSpecialArgs = configuration.workstation; }

            ./modules/docker.nix
            ./modules/steam.nix
            ./modules/tailscale/exit-node.nix

            ./modules/system/ups.nix
          ];
        };
      };
    };
}
