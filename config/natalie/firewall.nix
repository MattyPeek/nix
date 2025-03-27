{ config, pkgs, lib, ... }: {

    networking.firewall = {
        enable = true;

        # NAT table rules
        iptableNAT = ''
            *nat
            :POSTROUTING - [0:0]

            # Forward traffic from TUN devices
            -A POSTROUTING -o enp4s0 -j MASQUERADE

            # DNAT for incoming traffic on port 4000
            -A PREROUTING -p tcp -m tcp --dport 4000 -j DNAT --to-destination 78.24.8.73:4000

            COMMIT
        '';

        # Filter table rules
        iptableFilter = ''
            *filter
            :INPUT DROP [0:0]
            :FORWARD DROP [0:0]
            :OUTPUT ACCEPT [0:0]

            :UDP - [0:0]
            :TCP - [0:0]
            :ICMP - [0:0]

            # Accept SSH
            -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

            # Accept established connections
            -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

            # Accept local
            -A INPUT -i lo -j ACCEPT

            # Drop invalid connections
            -A INPUT -m conntrack --ctstate INVALID -j DROP

            # Allow ICMP packets
            -A INPUT -p icmp -m conntrack --ctstate NEW -j ICMP
            -A INPUT -p icmp -j ACCEPT

            # OpenVPN connection
            -A INPUT -p udp -m udp --dport 1194 -j ACCEPT

            # WireGuard (WG)
            -A INPUT -p udp --dport 51820 -j ACCEPT
            -A INPUT -p udp --dport 12312 -j ACCEPT

            # Allow traffic from the 10.0.0.0/8 subnet
            -A INPUT -s 10.0.0.0/8 -j ACCEPT

            # Accept traffic from "server" interface (wireguard)
            -A INPUT -i server -p icmp -j ACCEPT
            -A INPUT -i server -p udp -j ACCEPT
            -A INPUT -i server -p tcp --syn -j ACCEPT
            -A INPUT -i server -j ACCEPT
            -A FORWARD -i server -j ACCEPT

            # Accept related and established connections
            -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
            -A FORWARD -i server -o enp4s0 -j ACCEPT

            # Allow connections from specific subnets
            -A INPUT -s 192.168.177.0/24 -j ACCEPT
            -A INPUT -s 192.168.69.0/24 -j ACCEPT

            # Allow TUN/TAP interface connections (for VPNs like OpenVPN)
            -A INPUT -i tun+ -j ACCEPT
            -A FORWARD -i tun+ -j ACCEPT
            -A INPUT -i tap+ -j ACCEPT
            -A FORWARD -i tap+ -j ACCEPT
            -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
            -A FORWARD -i tun+ -o enp4s0 -j ACCEPT

            # Internet sharing
            -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
            -A FORWARD -i enp3s0f0 -o enp4s0 -j ACCEPT

            # jmeter traffic (allow specific IPs)
            -A INPUT -s 78.24.10.117 -j ACCEPT
            -A INPUT -s 78.24.10.118 -j ACCEPT
            -A INPUT -s 78.24.10.119 -j ACCEPT
            -A INPUT -s 78.24.10.120 -j ACCEPT
            -A INPUT -s 78.24.10.121 -j ACCEPT
            -A INPUT -s 78.24.10.122 -j ACCEPT
            -A INPUT -s 78.24.10.123 -j ACCEPT
            -A INPUT -s 78.24.10.124 -j ACCEPT
            -A INPUT -s 78.24.10.125 -j ACCEPT
            -A INPUT -s 78.24.10.126 -j ACCEPT

            -A FORWARD -s 78.24.10.117 -j ACCEPT
            -A FORWARD -s 78.24.10.118 -j ACCEPT
            -A FORWARD -s 78.24.10.119 -j ACCEPT
            -A FORWARD -s 78.24.10.120 -j ACCEPT
            -A FORWARD -s 78.24.10.121 -j ACCEPT
            -A FORWARD -s 78.24.10.122 -j ACCEPT
            -A FORWARD -s 78.24.10.123 -j ACCEPT
            -A FORWARD -s 78.24.10.124 -j ACCEPT
            -A FORWARD -s 78.24.10.125 -j ACCEPT
            -A FORWARD -s 78.24.10.126 -j ACCEPT

            # Allow traffic for jmeter (specific destination and port)
            -A FORWARD -m state -p tcp -d 10.0.0.2 --dport 4000 --state NEW,ESTABLISHED,RELATED -j ACCEPT

            COMMIT
        '';
    };
}
