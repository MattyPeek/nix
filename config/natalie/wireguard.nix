{ config, pkgs, lib, ... }: {

    #networking.wireguard.enable = true;

    networking.wireguard.interfaces = {
        server = {
            privateKeyFile = "/etc/wireguard/server.pk";
            listenPort = 12312;
            ips = [
                "10.0.1.1/24"
            ];
            peers = [
                {# mcbp
                    publicKey = "POtqcv0cN/wjGtUFRB9xcXch14x7Zp+aCl052NVyfmk=";
                    allowedIPs = [ "10.0.1.2/32" ];
                }
                {# iPhone 14 Pro
                    publicKey = "dSI+/Q5AlwJRCqYi1JdcadTKwAxuBG7u/R6EgzFn4W4=";
                    allowedIPs = [ "10.0.1.3/32" ];
                }
            ];
        };
    };

    systemd.services."wg-quick@server" = {
        description = "WireGuard VPN Interface";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${pkgs.wireguard-tools}/bin/wg-quick up server";
        serviceConfig.ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down server";
    };

    networking.firewall.allowedTCPPorts = [ 12312 ];
    networking.firewall.allowedUDPPorts = [ 12312 ];
}

