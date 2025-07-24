{ config, lib, pkgs, ... }: {
    services.cron = {
        enable = true;
        systemCronJobs = [
        {
            #minute = "*/10";
            #user = "root";
            #command = "/srv/monitoring/home-internet-check.py";
            "*/10 * * * * root /srv/monitoring/home-internet-check.py"
        }
        ];
    };
}
