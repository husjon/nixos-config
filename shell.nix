{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = with pkgs; [
    # your packages here
    gh
    git-crypt
    nixpkgs-fmt
    nil
    sops
  ];
}
