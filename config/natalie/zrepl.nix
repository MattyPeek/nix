{ config, lib, pkgs, disko, ... }: {
    services.zrepl = {
        enable = true;
        settings = ''
            global:
              logging:
                - type: syslog
                  format: human
                  level: warn
            jobs:
              - name: natalie-backup
                type: push
                connect:
                  type: ssh+stdinserver
                  host: brokolice.pesek.pro
                  user: maty
                  port: 412
                  identity_file: /etc/zrepl/ssh/id_ed25519
                  client_identity: pushclient
                  options:
                    - "Compression=yes"
                filesystems: {
                  "pool1/system": true,
                }
                snapshotting:
                  type: periodic
                  prefix: zrepl_
                  interval: 300s
        '';
    };
}
