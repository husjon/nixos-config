{
  description = "NixOS flake for husjon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:

    let
      system = "x86_64-linux";

      configuration = import ./configuration/args.nix { inherit inputs; };
      laptop = configuration.laptop // {
        inherit inputs;
      };

    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = laptop;

          modules = [ ./configuration ];
        };
      };
    };
}
