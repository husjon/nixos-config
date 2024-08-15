{ ... }:

rec {
  user = {
    username = "husjon";
  };

  laptop = {
    hostname = "laptop";

    graphics = "intel";

    user = user;

    stateVersion = "23.11";
  };
}
