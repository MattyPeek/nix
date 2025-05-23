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
            ];
        };
    };                                   
}
