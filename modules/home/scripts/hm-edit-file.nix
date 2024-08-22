{ ... }:
{
  home.file.".local/bin/hm-edit-file" = {
    executable = true;

    text = ''
      #!/usr/bin/env bash

      set -e

      FILE=''${1}

      if [ ! ''${FILE} ]; then echo -e "Usage:\n $(basename ''${0}) <path>"; exit 1; fi

      ORIGINAL_FILE=$(readlink $FILE || echo "")

      # Once editor or terminal is closed, reinstate the symlink
      trap 'ln -sf ''${ORIGINAL_FILE} ''${FILE}' EXIT TERM INT HUP

      if ! echo "''${ORIGINAL_FILE}" | grep -E '^/nix/store/.*?-home-manager-files/' > /dev/null; then
          echo "File \"''${FILE}\" is not managed by home-manager"; exit 1
      fi

      # Remove the symlink
      rm ''${FILE}

      # Read the content of the original file into a new file (makes the file writable)
      cat ''${ORIGINAL_FILE} > ''${FILE}

      # Edit the file with the user specified EDITOR
      $EDITOR ''${FILE}
    '';
  };
}
