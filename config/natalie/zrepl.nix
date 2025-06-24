{ config, lib, pkgs, disko, ... }: {
    services.zrepl = {
        enable = true;
        settings = {
            global = {
                logging = [
                {
                    type = "syslog";
                    format = "human";
                    level = "warn";
                }
                ];
            };
            jobs = [
            {
                name = "natalie-backup";
                type = "push";
                connect = {
                    type = "ssh+stdinserver";
                    host = "brokolice.pesek.pro";
                    user = "maty";
                    port = 412;
                    identity_file = "/etc/zrepl/ssh/id_ed25519";
                    options = [ "Compression=yes" ];
                };
                send = {
                    #encrypted = "true";
                    large_blocks = true;
                    #properties= true;
                };
                filesystems = {
                    "pool1/system<" = true;
                };
                snapshotting = {
                    type = "periodic";
                    prefix = "zrepl_";
                    interval = "5m";
                };
                pruning = {
                    keep_sender = [
                    {
                        type = "last_n";
                        count = 12;
                    }
                    ];
                    keep_receiver = [
                    {
                        type = "grid";
                        grid = "1x1h(keep=all) | 24x1h | 7x1d";
                        regex = "^zrepl_.*";
                    }
                    ];
                };
            }
            {
                name = "brokolice-backup";
                type = "sink";

                root_fs = "pool1/backup";
                serve = {
                    type = "stdinserver";
                    client_identities = [ "brokolice" ];
                    # Since vers. 0.7.0
                    #socket_dir = "/var/run/zrepl/stdinserver";
                    #socket_permissions = {
                    #    user = "maty";
                    #    group = "zrepl";
                    #    mode = "0770";
                    #};
                };
                recv = {
                    placeholder = {
                        encryption = "inherit";
                    };
                };
            }
            ];
        };
    };                                   
    systemd.services.zrepl.serviceConfig.ExecStartPost = lib.mkAfter [
        "/run/current-system/sw/bin/bash -c 'echo \"Running chown script...\"; for i in {1..10}; do if compgen -G \"/var/run/zrepl/stdinserver/*\" > /dev/null; then /run/current-system/sw/bin/chgrp -R zrepl /var/run/zrepl ; /run/current-system/sw/bin/chmod -R 770 /var/run/zrepl ; /run/current-system/sw/bin/chmod g+s /var/run/zrepl ; echo \"chown succeeded...\"; exit 0; fi; sleep 0.5; done; echo \"Socket did not appear in time\" >&2 ; exit 1 ; ' "
    ];
}
