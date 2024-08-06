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
            ../../modules/nix-store-maintenance.nix

            ../../modules/fstrim.nix
            ../../modules/locale.nix

            ../../modules/desktop

            ../../modules/desktop/graphics/intel.nix

            ../../modules/desktop/wayland/default.nix
            ../../modules/desktop/wayland/hyprland.nix

            ({ ... }: { services.udev.extraRules = builtins.readFile ./laptop/secrets/99-yubikey.rules; })

            ../../modules/tailscale
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
            ../../modules/nix-store-maintenance.nix

            ../../modules/fstrim.nix
            ../../modules/locale.nix

            ../../modules/desktop
            ../../modules/desktop/3d-printing.nix
            ../../modules/desktop/blender-amd.nix
            ../../modules/desktop/calibre.nix
            ../../modules/desktop/godot.nix
            ../../modules/desktop/krita.nix
            ../../modules/desktop/steam.nix
            ({ ... }: { services.udev.extraRules = builtins.readFile ./workstation/secrets/99-yubikey.rules; })

            ../../modules/desktop/wayland/default.nix
            ../../modules/desktop/wayland/hyprland.nix

            ../../modules/docker.nix
            ../../modules/desktop/bluetooth.nix

            ../../modules/tailscale
            ../../modules/tailscale/exit-node.nix
          ];
        };

        workstation-sb = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit user_settings;
          };
          modules = [
            ({ ... }: {
              nixpkgs.overlays = [ overlays-nixpkgs ];
            })
            ./workstation-sb/configuration.nix
            sops-nix.nixosModules.sops
            ../../modules/nix-store-maintenance.nix

            ../../modules/fstrim.nix
            ../../modules/locale.nix

            ../../modules/desktop/graphics/nvidia.nix

            ../../modules/desktop
            ../../modules/desktop/blender.nix
            ../../modules/desktop/bluetooth.nix

            ../../modules/desktop/krita.nix

            ../../modules/desktop/x11/default.nix
            ../../modules/desktop/x11/i3.nix

            ({ ... }: { services.udev.extraRules = builtins.readFile ./workstation-sb/secrets/99-yubikey.rules; })

            ../../modules/docker.nix

            ../../modules/tailscale
          ];
        };
      };
    };
}
