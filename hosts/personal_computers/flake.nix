{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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

      user_settings = {
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
            ./laptop/configuration.nix
            sops-nix.nixosModules.sops

            ../../modules/desktop

            ../../modules/desktop/graphics/intel.nix

            ../../modules/desktop/wayland/default.nix
            ../../modules/desktop/wayland/hyprland.nix

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
            ./workstation/configuration.nix
            sops-nix.nixosModules.sops

            ../../modules/desktop
            ../../modules/desktop/3d-printing.nix
            ../../modules/desktop/blender.nix
            ../../modules/desktop/calibre.nix
            ../../modules/desktop/godot.nix
            ../../modules/desktop/krita.nix
            ../../modules/desktop/steam.nix

            ../../modules/desktop/wayland/default.nix
            ../../modules/desktop/wayland/hyprland.nix

            ../../modules/docker.nix

            ../../modules/tailscale
          ];
        };
      };
    };
}
