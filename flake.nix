{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";

    hyprcursor.url = "github:hyprwm/hyprcursor/main";
    hyprlock.url = "github:hyprwm/hyprlock/main";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hypridle.url = "github:hyprwm/hypridle/main";
    hypridle.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hyprpaper.url = "github:hyprwm/hyprpaper/main";
    hyprpicker.url = "github:hyprwm/hyprpicker/main";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      home-manager,
      ...
    }:

    let
      system = "x86_64-linux";

      overlays-nixpkgs = final: prev: {
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
