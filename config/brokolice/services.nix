{ config, lib, pkgs, ... }: {
    systemd.services.ticket-checker = {
        enable = true;
        description = "VSH IS ticket checker";
        unitConfig = {
            Type = "simple";
            # ...
        };
        serviceConfig = {
            ExecStart = "/opt/ticket/checker";
            Restart = on-failure;
            # ...
        };
        wantedBy = [ "multi-user.target" ];
        # ...
    };
}
