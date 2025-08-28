with import <nixpkgs> { };

let
  sops-nix = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
  };
in

pkgs.mkShell {
  shellHook = ''
    git config core.hooksPath .git-hooks

    export NIL_PATH="${pkgs.nil}/bin/nil"
  '';

  sopsPGPKeyDirs = [
    "${toString ./.}/keys/hosts"
    "${toString ./.}/keys/users"
  ];
  nativeBuildInputs = [ (pkgs.callPackage sops-nix { }).sops-import-keys-hook ];

  sopsCreateGPGHome = true;

  packages = with pkgs; [
    # your packages here
    gh
    git-crypt
    nixfmt-rfc-style
    nil
    shfmt
    sops

    (writeShellScriptBin "f" ''
      nvim -c 'lua require("persistence").load()'
    '')

    (writeShellScriptBin "rebuild-test" ''
      sudo nixos-rebuild --flake ".#" --no-update-lock-file test
    '')
    (writeShellScriptBin "rebuild-switch" ''
      sudo nixos-rebuild --flake ".#" --no-update-lock-file switch
    '')

    (writeShellScriptBin "rebuild-vm" ''
      nixos-rebuild --flake ".#" --no-update-lock-file build-vm

      QEMU_OPTS="-display gtk,grab-on-hover=on -smp cpus=4" \
        ./result/bin/run-*-vm
      rm ./result ./*.qcow2
    '')

    (writeShellScriptBin "rebuild-remote" ''
      #!/usr/bin/env bash

      case ''$1 in
          # Personal Computers
          laptop|workstation)
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
              --no-update-lock-file \
              ''${OPERATION}
      fi
    '')
  ];
}
