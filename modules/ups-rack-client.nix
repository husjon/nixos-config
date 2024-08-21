{
  config,
  lib,
  pkgs,
  ...
}:

let
  upsschedCmd = pkgs.writeScriptBin "upssched-cmd" ''
    #!${pkgs.bash}/bin/bash

    log() {
    	${pkgs.util-linux}/bin/logger -t upssched-cmd "$1"
    	echo "$(date) upssched-cmd: $1" | tee -a /tmp/upssched-cmd.log
    }

    case $1 in
    	onbatt)
    		log "UPS on battery for too long, shutting down!"
    		/run/current-system/sw/bin/upsmon -c fsd
    		;;
    	commbad|nocomm)
    		log "UPS has been gone for a while, shutting down!"
    		/run/current-system/sw/bin/upsmon -c fsd
    		;;
    	earlyshutdown|lowbatt)
    		log "Shutting down early!"
    		/run/current-system/sw/bin/upsmon -c fsd
    		;;
    	*)
    		log "Unrecognized command: $1"
    		;;
    esac
  '';

  upsschedConf = pkgs.writeText "upssched.conf" ''
    CMDSCRIPT ${upsschedCmd}/bin/upssched-cmd

    PIPEFN /etc/nut/upssched.pipe
    LOCKFN /etc/nut/upssched.lock

    # AT <notifytype>   <upsname>   <command>
    # START-TIMER           <timername>     <interval>
    # CANCEL-TIMER          <timername>     [cmd]
    # EXECUTE               <command>
    AT ONBATT       *       START-TIMER     onbatt 240
    AT ONLINE       *       CANCEL-TIMER    onbatt
    AT LOWBATT      *       EXECUTE         lowbatt

    AT COMMBAD      *       START-TIMER     commbad 240
    AT COMMOK       *       CANCEL-TIMER    commbad
    AT NOCOMM       *       EXECUTE         nocomm

    AT SHUTDOWN     *       EXECUTE         earlyshutdown
  '';

in
{
  sops.secrets.nut_pass = { };

  power.ups.enable = true;
  power.ups.mode = "netclient";
  power.ups.upsmon = {
    monitor = {
      "ups@proxmox.husjon.xyz" = {
        user = "upsmon";
        passwordFile = config.sops.secrets.nut_pass.path;
        type = "secondary";
      };
    };

    settings = {
      POLLFREQ = 2;
      POLLFREQALERT = 1;
      HOSTSYNC = 15;
      DEADTIME = 15;

      RBWARNTIME = 43200;
      NOCOMMWARNTIME = 600;
      FINALDELAY = 5;

      NOTIFYFLAG = [
        [
          "ONLINE"
          "SYSLOG+EXEC"
        ]
        [
          "ONBATT"
          "SYSLOG+EXEC"
        ]
        [
          "LOWBATT"
          "SYSLOG"
        ]
        [
          "FSD"
          "SYSLOG+EXEC"
        ]
        [
          "COMMOK"
          "SYSLOG+EXEC"
        ]
        [
          "COMMBAD"
          "SYSLOG+EXEC"
        ]
        [
          "SHUTDOWN"
          "SYSLOG+EXEC"
        ]
        [
          "REPLBATT"
          "SYSLOG"
        ]
        [
          "NOCOMM"
          "SYSLOG+EXEC"
        ]
        [
          "NOPARENT"
          "SYSLOG"
        ]
      ];
      NOTIFYMSG = [
        [
          "ONLINE"
          "UPS %s on line power"
        ]
        [
          "ONBATT"
          "UPS %s on battery"
        ]
        [
          "LOWBATT"
          "UPS %s battery is low"
        ]
        [
          "FSD"
          "UPS %s: forced shutdown in progress"
        ]
        [
          "COMMOK"
          "Communications with UPS %s established"
        ]
        [
          "COMMBAD"
          "Communications with UPS %s lost"
        ]
        [
          "SHUTDOWN"
          "Auto logout and shutdown proceeding"
        ]
        [
          "REPLBATT"
          "UPS %s battery needs to be replaced"
        ]
        [
          "NOCOMM"
          "UPS %s is unavailable"
        ]
        [
          "NOPARENT"
          "upsmon parent process died - shutdown impossible"
        ]
      ];

    };
  };

  environment.etc = {
    "nut/upssched.conf" = lib.mkForce { source = upsschedConf; };
    "nut/upssched-cmd" = {
      source = upsschedCmd;
    };
  };
}
