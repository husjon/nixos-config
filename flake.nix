{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    hyprlock.url = "github:hyprwm/hyprlock/main";
    hypridle.url = "github:hyprwm/hypridle/main";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix
            ./modules/desktop.nix
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
            ./modules/steam.nix
          ];
        };
      };
    };
}
