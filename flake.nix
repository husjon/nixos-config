{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    hyprcursor.url = "github:hyprwm/hyprcursor/main";
    hyprlock.url = "github:hyprwm/hyprlock/main";
    hypridle.url = "github:hyprwm/hypridle/main";
    hyprpicker.url = "github:hyprwm/hyprpicker/main";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix

            ./modules/desktop
            ./modules/desktop/hyprland.nix
            ./modules/desktop/audio.nix
          ];
        };

        workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/workstation/configuration.nix

            ./modules/desktop
            ./modules/desktop/hyprland.nix
            ./modules/desktop/audio.nix
            ./modules/docker.nix
            ./modules/steam.nix
          ];
        };
      };
    };
}
