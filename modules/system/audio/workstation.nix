{ ... }:
{
  services.pipewire = {
    extraConfig.pipewire = {
      "50-game_sink" = {
        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "capture.props" = {
                "node.description" = "Games";
                "node.name" = "games_sink";
                "media.class" = "Audio/Sink";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
              "playback.props" = {
                "node.description" = "Games";
                "node.name" = "games_source";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
            };
          }
        ];
      };
    };

    wireplumber.extraConfig = {
      "10-disabled_devices" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.pci-0000_13_00.6"; } ];
            actions = {
              "update-props" = {
                "device.disabled" = true;
              };
            };
          }
          {
            matches = [ { "device.name" = "alsa_card.usb-046d_C922_Pro_Stream_Webcam_9BBBD36F-02"; } ];
            actions = {
              "update-props" = {
                "device.disabled" = true;
              };
            };
          }
        ];
      };

      "10-amd_radeon_7800xt.conf" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.nick" = "HDA ATI HDMI";
                "media.class" = "Audio/Device";
                "device.name" = "alsa_card.pci-0000_03_00.1";
              }
            ];
            actions = {
              "update-props" = {
                "device.description" = "AMD Radeon 7800 XT";
                "device.profile" = "pro-audio";
              };
            };
          }
          {
            matches = [
              {
                "node.name" = "~alsa_output.pci-0000_03_00.1.*";
                "object.path" = "alsa:acp:HDMI:0:playback";
              }
            ];
            actions = {
              "update-props" = {
                "node.description" = "Primary Monitor";
                "node.disabled" = true;
              };
            };
          }
          {
            matches = [
              {
                "node.name" = "~alsa_output.pci-0000_03_00.1.*";
                "object.path" = "alsa:acp:HDMI:1:playback";
              }
            ];
            actions = {
              "update-props" = {
                "node.description" = "Secondary Monitor";
                "node.disabled" = true;
              };
            };
          }
          {
            matches = [
              {
                "node.name" = "~alsa_output.pci-0000_03_00.1.*";
                "object.path" = "alsa:acp:HDMI:2:playback";
              }
            ];
            actions = {
              "update-props" = {
                "node.description" = "TV";
              };
            };
          }
          {
            matches = [
              {
                "node.name" = "~alsa_output.pci-0000_03_00.1.*";
                "object.path" = "alsa:acp:HDMI:3:playback";
              }
            ];
            actions = {
              "update-props" = {
                "node.description" = "Tablet";
                "node.disabled" = true;
              };
            };
          }
        ];
      };

      "10-behringer_umc_404hd.conf" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.usb-BEHRINGER_UMC404HD_192k-00"; } ];
            actions = {
              "update-props" = {
                "device.profile" = " HiFi";
                "audio.rate" = 192000;
                "audio.allowed-rates" = "44100,48000,88200,96000,192000";
              };
            };
          }
          {
            matches = [ { "node.name" = "alsa_output.usb-BEHRINGER_UMC404HD_192k-00.HiFi__Line1__sink"; } ];
            actions = {
              "update-props" = {
                "node.description" = "Headset";
              };
            };
          }
          {
            matches = [ { "node.name" = "alsa_output.usb-BEHRINGER_UMC404HD_192k-00.HiFi__Line2__sink"; } ];
            actions = {
              "update-props" = {
                "node.description" = "Speakers";
              };
            };
          }
        ];
      };
    };
  };
}
