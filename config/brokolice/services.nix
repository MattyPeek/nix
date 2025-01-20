{ config, lib, pkgs, ... }: {
    systemd.services.ticket-checker = {
        enable = true;
        description = "VSH IS ticket checker";
        unitConfig = {
            Type = "simple";
            # ...
        };
        serviceConfig = {
            Environment = "PATH=/run/current-system/sw/bin";
            ExecStart = "/opt/ticket-checker";
            Restart = "on-failure";
            # ...
        };
        wantedBy = [ "multi-user.target" ];
        # ...
    };
}
