{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    # your packages here
    gh
    nixpkgs-fmt
    nil
    sops
  ];
}
