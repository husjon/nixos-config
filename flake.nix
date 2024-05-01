{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprcursor.url = "github:hyprwm/hyprcursor/main";
    hyprlock.url = "github:hyprwm/hyprlock/main";
    hypridle.url = "github:hyprwm/hypridle/main";
    hyprpicker.url = "github:hyprwm/hyprpicker/main";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, sops-nix, ... }:

    let
      system = "x86_64-linux";

      overlays-nixpkgs = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      user_settings = rec {
        username = "husjon";
      };

    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit user_settings;
          };
          modules = [
            ({ ... }: {
              nixpkgs.overlays = [ overlays-nixpkgs ];
            })
            ./hosts/laptop/configuration.nix
            sops-nix.nixosModules.sops

            ./modules/desktop
            ./modules/desktop/hyprland.nix
            ./modules/desktop/audio.nix
          ];
        };

        workstation = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit user_settings;
          };
          modules = [
            ({ ... }: {
              nixpkgs.overlays = [ overlays-nixpkgs ];
            })
            ./hosts/workstation/configuration.nix
            sops-nix.nixosModules.sops

            ./modules/desktop
            ./modules/desktop/hyprland.nix
            ./modules/desktop/audio.nix
            ./modules/blender.nix
            ./modules/docker.nix
            ./modules/steam.nix
          ];
        };
      };
    };
}
