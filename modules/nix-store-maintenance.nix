{ ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  nix.optimise = {
    automatic = true;
    dates = [
      "03:45"
    ];
  };
}
