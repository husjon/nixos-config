{ ... }:
{

  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
  };

  xdg.configFile = {
    # https://github.com/direnv/direnv/wiki/Customizing-cache-location#human-readable-directories
    # Stores the cache in a human-readable form:
    #   ~/.cache/direnv/layouts/8413d4b7d3d4277de6191850443c9f2c6c8dcaf5-home-user-foo

    "direnv/direnvrc".text = ''
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';
  };
}
