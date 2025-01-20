{ config, lib, pkgs, ... }: {
    systemd.services.ticket-checker = {
        enable = true;
        description = "VSH IS ticket checker";
        unitConfig = {
            Type = "simple";
            # ...
        };
        serviceConfig = {
            ExecStart = /usr/bin/env nix-shell -p jq curl --run "/opt/ticket-checker";
            Restart = "on-failure";
            # ...
        };
        wantedBy = [ "multi-user.target" ];
        # ...
    };
}
