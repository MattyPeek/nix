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
                    #listen = ":8888";
                };
            }
            ];
        };
    };                                   
}
