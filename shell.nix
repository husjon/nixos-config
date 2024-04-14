{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    # your packages here
    nixpkgs-fmt
    sops
  ];
}
