{ inputs, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = builtins.concatStringsSep " " [
      "--delete-old"
      "--delete-older-than 7d"
    ];
  };

  # Prevent all Flake inputs from being garbage collected
  # ref: https://github.com/NixOS/nix/issues/3995#issuecomment-2081164515
  system.extraDependencies =
    let
      collectFlakeInputs =
        input:
        [ input ] ++ builtins.concatMap collectFlakeInputs (builtins.attrValues (input.inputs or { }));
    in
    builtins.concatMap collectFlakeInputs (builtins.attrValues inputs);

  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };
}
