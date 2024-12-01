{
  description = "NixOS flake for husjon";

  inputs = {
    # Nix channel status: https://status.nixos.org/
    # https://discourse.nixos.org/t/differences-between-nix-channels/13998
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";

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
        (
          { ... }:
          {
            nixpkgs.overlays = [ overlays-nixpkgs ];
          }
        )

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

            ./modules/3d-printing.nix
            ./modules/blender.nix
            ./modules/calibre.nix
            ./modules/docker.nix
            ./modules/godot.nix
            ./modules/krita.nix
            ./modules/steam.nix
          ];
        };

        laptop-sb = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = configuration.laptop-sb // {
            inherit inputs;
          };

          modules = commonModules ++ [
            { home-manager.extraSpecialArgs = configuration.laptop-sb; }
            ./modules/system/tlp.nix

            ./modules/docker.nix
          ];
        };

        workstation-sb = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = configuration.workstation-sb // {
            inherit inputs;
          };

          modules = commonModules ++ [
            { home-manager.extraSpecialArgs = configuration.workstation-sb; }

            ./modules/3d-printing.nix
            ./modules/blender.nix
            ./modules/docker.nix

            (
              { pkgs, ... }:
              {
                nixpkgs.config = {
                  packageOverrides = pkgs: { polybar = pkgs.polybar.override { i3Support = true; }; };
                };
              }
            )
          ];
        };
      };
    };
}
