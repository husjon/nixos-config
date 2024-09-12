{ ... }:
{
  services.tlp = {
    enable = true;
  };

  services.upower = {
    enable = true;

    percentageLow = 15;
    percentageCritical = 5;
    criticalPowerAction = "Hibernate"; # one of "PowerOff", "Hibernate", "HybridSleep"
  };
}
