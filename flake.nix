{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";

    hyprcursor.url = "github:hyprwm/hyprcursor/main";
    hyprlock.url = "github:hyprwm/hyprlock/main";
    hypridle.url = "github:hyprwm/hypridle/main";
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
          home-manager.users."${configuration.user.username}" = import ./modules/home;
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

          modules = commonModules ++ [ { home-manager.extraSpecialArgs = configuration.laptop; } ];
        };
      };
    };
}
