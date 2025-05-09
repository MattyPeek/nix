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
    #systemd.services.zrepl.serviceConfig.ExecStartPost = lib.mkAfter [
    #    "/run/current-system/sw/bin/chown maty:zrepl /var/run/zrepl/stdinserver/*"
    #];
}
