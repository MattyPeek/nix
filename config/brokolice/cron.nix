{ config, lib, pkgs, ... }: {
    services.cron = {
        enable = true;
        systemCronJobs = [
        {
            # Run every 5 minutes
            minute = "*/10";
            user = "root";
            command = "/srv/monitoring/home-internet-check.py";
        }
        ];
    };
}
