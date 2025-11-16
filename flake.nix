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

      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = configuration.${hostname} // {
            inherit inputs hostname;
          };

          modules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops

            { nixpkgs.overlays = [ overlays-nixpkgs ]; }

            ./configuration
            ./modules
          ];
        };

    in
    {
      nixosConfigurations = {
        laptop = mkSystem "laptop";
        workstation = mkSystem "workstation";
      };
    };
}
