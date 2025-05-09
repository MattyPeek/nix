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
                type = "sink";
                
                root_fs = "pool1/backup";
                serve = {
                    type = "stdinserver";
                    client_identities = [ "natalie" ];
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
        ''
            /run/current-system/sw/bin/bash -c '
                echo "Running chown script..."
                for i in {1..10}; do
                    if compgen -G "/var/run/zrepl/stdinserver/*" > /dev/null; then
                        /run/current-system/sw/bin/chown :zrepl /var/run/zrepl/stdinserver/*
                        /run/current-system/sw/bin/chmod 0770 /var/run/zrepl/stdinserver/*
                        echo "chown succeeded..."
                        exit 0
                    fi
                    sleep 0.5
                done
                echo "Socket did not appear in time" >&2
                exit 1
            '
        ''
    ];
}
