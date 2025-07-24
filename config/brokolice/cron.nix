{ config, lib, pkgs, ... }: {
    services.cron = {
        enable = true;
        systemCronJobs = [
            "*/10 * * * * root /srv/monitoring/home-internet-check.py"
        ];
    };
}
