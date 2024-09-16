# https://stackoverflow.com/questions/78358294/deeply-merge-sets-in-nix
let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;
  set_one = {
    nested_set = {
      x = 1;
      y = 2;
    };
    a = [
      1
      2
      3
    ];
  };
  set_two = {
    nested_set = {
      x = 0;
    };
    a = [ 4 ];
  };
in
lib.recursiveUpdate set_one set_two

# nix-instantiate --eval --strict test.nix
