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
  ];
}
