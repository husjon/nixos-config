{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  shellHook = ''
    git config core.hooksPath .git-hooks

    export NIL_PATH="${pkgs.nil}/bin/nil"
  '';

  packages = with pkgs; [
    # your packages here
    gh
    git-crypt
    nixfmt-rfc-style
    nil
    sops

    (writeShellScriptBin "f" ''
      /usr/bin/env nvim flake.nix
    '')

    (writeShellScriptBin "rebuild-test" ''
      sudo nixos-rebuild --flake ".#" test
    '')
    (writeShellScriptBin "rebuild-switch" ''
      sudo nixos-rebuild --flake ".#" switch
    '')
  ];
}
