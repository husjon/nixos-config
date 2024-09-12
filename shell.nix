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

    (writeShellScriptBin "rebuild-remote" ''
      #!/usr/bin/env bash

      case ''$1 in
          # Personal Computers
          laptop|workstation|workstation-sb)
              HOST=''$1
              ;;
          *)
              echo "unknown target"
              exit 1
              ;;
      esac


      case ''$2 in
          switch|test|dry-build)
              OPERATION=''$2
              ;;
          *)
              echo "unknown operation (supported: switch, test)"
              exit 1
              ;;
      esac

      if [ ''${HOST} = ''$(hostname) ]; then
          echo 'Use "rebuild-test" or "rebuild-switch" instead'
          exit 1
      else
          NIX_SSHOPTS="-o ControlPath=''$HOME/.ssh/controlmasters-%r@%h:22 -o ControlMaster=auto -o ControlPersist=10s " \
          nixos-rebuild \
              --build-host "root@''${HOST}" \
              --target-host "root@''${HOST}" \
              --flake ".#''${HOST}" \
              ''${OPERATION}
      fi
    '')
  ];
}
