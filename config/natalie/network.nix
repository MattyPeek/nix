{ config, lib, pkgs, ... }: {

    networking.networkmanager.enable = true;
    networking.interfaces.enp4s0 = {
        ipv4 = {
            addresses = [ {
                #address = "78.24.8.73";
                address = "192.168.51.11";
                #prefixLength = 28;
                prefixLength = 24;
            }];
            #gateway = "78.24.8.65";
            gateway = "192.168.51.1";
            dns = [
                "1.1.1.1"
                "8.8.8.8"
            ];
        };
        ipv6 = {
            addresses = [{ 
                address = "00:1ed0:3c::dead:b00b"; 
                prefixLength = 64; 
            }];
            gateway = "2a00:1ed0:3c::1";
            dns = [ 
                "2001:4860:4860::1111" 
                "2606:4700:4700::8888" 
            ];
        };
    };
    networking.interfaces.enp3s0f0 = {
        ipv4.addresses = [ {
            address = "10.0.0.1";
            prefixLength = 24;
        }];
    };

}
