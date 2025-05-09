{ config, lib, pkgs, disko, ... }: {
    services.zrepl = {
        enable = true;
        settings = {
            global:
              logging:
                - type: syslog
                  format: human
                  level: warn
            jobs:
              - name: natalie-backup
                type: source
                send:
                  large_blocks: true
                  compressed: true
                filesystems: {
                  "pool1/system": true,
                }
                serve:
                  type: tcp
                  listen: "78.24.8.73:8888"
                  clients: {
                    "93.185.110.51" : "brokolice"
                  }
                snapshotting:
                  type: periodic
                  prefix: zrepl_
                  interval: 300s
        };
    };
}
