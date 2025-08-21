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

        # Temporary while waiting for v0.10.0 (fix for adding albums: https://github.com/mierak/rmpc/issues/669)
        rmpc = prev.rmpc.override {
          # override based on https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/10

          rustPlatform = final.rustPlatform // {
            buildRustPackage =
              args:
              final.rustPlatform.buildRustPackage (
                args
                // {
                  src = prev.fetchFromGitHub {
                    owner = "mierak";
                    repo = "rmpc";
                    rev = "cbe94e6d4dbb1e96c032e483aedf2a976f9c4756";
                    hash = "sha256-Ey8t2RhEc0YRNBIuakXNvsnPwuAfPLBAmjofUD36ry4=";
                  };

                  cargoHash = "sha256-d2/4q2s/11HNE18D8d8Y2yWidhT+XsUS4J9ahnxToI0=";
                }
              );
          };
        };

      };

      configuration = import ./configuration/args.nix { inherit inputs; };

      commonModules = [
        ./configuration
        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager
        ({ nixpkgs.overlays = [ overlays-nixpkgs ]; })
        { husjon.user.profilePicture = ./configuration/husjon.png; }

        ./modules
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
            {
              husjon.graphics.manufacturer = "intel";
              husjon.system.tlp.enable = true;
              husjon.system.hibernation.enable = true;
              husjon.stateVersion = "24.11";
            }
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
                husjon.graphics.manufacturer = "amd";
                husjon.programs.blender.enable = true;
                husjon.programs.rmpc.enable = true;
                husjon.programs.steam.enable = true;
                husjon.programs.extraPrograms = with pkgs; [
                  calibre

                  freecad
                  godot_4
                  krita
                  lutris
                  prusa-slicer
                  tonelib-gfx

                  stable.vcv-rack
                ];
                husjon.services.borgmatic.enable = true;
                husjon.services.borgmatic.repositories = [
                  {
                    label = "local";
                    path = "/mnt/nvme0/borgmatic/";
                  }
                ];
                husjon.services.docker.enable = true;
                husjon.services.mpd.enable = true;
                husjon.services.tailscale.exitNode = true;
                husjon.system.kernel = "latest";
                husjon.system.ups.enable = true;
                husjon.stateVersion = "25.05";
              }
            )
          ];
        };
      };
    };
}
