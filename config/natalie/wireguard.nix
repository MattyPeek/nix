{ config, pkgs, lib, ... }: {

    networking.wireguard.enable = true;
    
    networking.wireguard.interfaces = {
        server = {
            listenPort = 12312;
            ips = [
                "10.0.1.1/24"
                "fd42:42:42::1/64"
            ];
            peers = [
                {# mcbp
                    publicKey = "POtqcv0cN/wjGtUFRB9xcXch14x7Zp+aCl052NVyfmk=";
                    allowedIPs = [ "10.0.1.2/32" "fd42:42:42::2" ];
                }
                {# iPhone 14 Pro
                    publicKey = "dSI+/Q5AlwJRCqYi1JdcadTKwAxuBG7u/R6EgzFn4W4=";
                    allowedIPs = [ "10.0.1.3/32" "fd42:42:42::3"];
                }
                {# boruvka-win
                    publicKey = "ECHN0QVlGFNzTIU+RQocywgw0OrLI+X7B5C/I/mSonY=";
                    allowedIPs = [ "10.0.1.4/32" "fd42:42:42::3"];
                }
            ];
            postSetup = ''
                ${pkgs.nftables}/bin/nft add table ip nat
                ${pkgs.nftables}/bin/nft add chain ip nat POSTROUTING { type nat hook postrouting priority 100 \; }
                ${pkgs.nftables}/bin/nft add rule ip nat POSTROUTING ip saddr 10.100.0.0/24 oifname "eth0" masquerade
                
                ${pkgs.nftables}/bin/nft add table ip6 nat
                ${pkgs.nftables}/bin/nft add chain ip6 nat POSTROUTING { type nat hook postrouting priority 100 \; }
                ${pkgs.nftables}/bin/nft add rule ip6 nat POSTROUTING ip6 saddr fd42:42:42::/64 oifname "eth0" masquerade
            '';
            postShutdown = ''
                ${pkgs.nftables}/bin/nft delete rule ip nat POSTROUTING ip saddr 10.100.0.0/24 oifname "eth0" masquerade
                ${pkgs.nftables}/bin/nft delete chain ip nat POSTROUTING
                ${pkgs.nftables}/bin/nft delete table ip nat

                ${pkgs.nftables}/bin/nft delete rule ip6 nat POSTROUTING ip6 saddr fd42:42:42::/64 oifname "eth0" masquerade
                ${pkgs.nftables}/bin/nft delete chain ip6 nat POSTROUTING
                ${pkgs.nftables}/bin/nft delete table ip6 nat
            '';
            privateKeyFile = "/srv/wireguard/server.pk";
        };
    };

    #networking.firewall.allowedTCPPorts = [ 12312 ];
    #networking.firewall.allowedUDPPorts = [ 12312 ];
}

