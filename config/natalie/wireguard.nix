{ config, pkgs, lib, ... }: {

    networking.wireguard.enable = true;
    
    networking.wireguard.interfaces = {
        server = {
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
            postSetup = ''
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';
            postShutdown = ''
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';
            privateKeyFile = "/srv/wireguard/server.pk";
        };
    };

    #networking.firewall.allowedTCPPorts = [ 12312 ];
    #networking.firewall.allowedUDPPorts = [ 12312 ];
}

