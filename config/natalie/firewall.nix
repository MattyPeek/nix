{ config, pkgs, lib, ... }: {
    
    networking.nftables.enable = true;
    
    networking.nat = {
        enable = true;
        internalInterfaces = [ "server" "enp3s0f0" ]; # Adjust to your interfaces
        externalInterface = "enp4s0"; # Adjust to your WAN interface
    };

    boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = "1";
        "net.ipv6.conf.all.forwarding" = "1";
    };

    networking.firewall = {
        enable = true;

        allowPing = true;

        allowedTCPPorts = [ 22 4000 12312 ]; # Allow SSH (22) and TCP 4000
        allowedUDPPorts = [ 1194 51820 12312 ]; # OpenVPN (1194), WireGuard (51820, 12312)
        allowedTCPPortRanges = [{ from = 3000; to = 3100; }];
        allowedUDPPortRanges = [{ from = 6000; to = 6010; }];
        
        trustedInterfaces = [ "lo" "server" "tun0" ];
        
        extraInputRules = ''
            ip saddr 10.0.0.0/8 accept
            ip saddr 10.0.1.0/8 accept
            ip saddr 192.168.177.0/24 accept
            ip saddr 192.168.69.0/24 accept

            # jmeter
            ip saddr 78.24.10.117 accept
            ip saddr 78.24.10.118 accept
            ip saddr 78.24.10.119 accept
            ip saddr 78.24.10.120 accept
            ip saddr 78.24.10.121 accept
            ip saddr 78.24.10.122 accept
            ip saddr 78.24.10.123 accept
            ip saddr 78.24.10.124 accept
            ip saddr 78.24.10.125 accept
            ip saddr 78.24.10.126 accept

            ct state related,established accept
        '';

        extraForwardRules = ''
            # jmeter
            ip saddr 78.24.10.117 accept
            ip saddr 78.24.10.118 accept
            ip saddr 78.24.10.119 accept
            ip saddr 78.24.10.120 accept
            ip saddr 78.24.10.121 accept
            ip saddr 78.24.10.122 accept
            ip saddr 78.24.10.123 accept
            ip saddr 78.24.10.124 accept
            ip saddr 78.24.10.125 accept
            ip saddr 78.24.10.126 accept

            ct state related,established accept

            ip daddr 10.0.0.2 tcp dport 4000 accept

            iifname enp3s0f0 oifname enp4s0 accept
        '';


    };
}
