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

  workstation = {
    hostname = "workstation";

    graphics = "amd";

    user = user;

    stateVersion = "23.11";
  };

  workstation-sb = {
    hostname = "workstation-sb";

    graphics = "nvidia";

    user = user;

    stateVersion = "23.11";
  };
}
