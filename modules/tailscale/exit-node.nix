{ ... }:

{
  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
      "--advertise-routes=10.0.0.0/24"
    ];
    useRoutingFeatures = "server";
  };
}
