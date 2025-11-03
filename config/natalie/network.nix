{ config, lib, pkgs, ... }: {

    networking.networkmanager.enable = true;

    networking.useDHCP = false;

    networking.interfaces.enp4s0 = {
        ipv4 = {
            addresses = [ {
                address = "78.24.8.73";
                prefixLength = 28;
            }];
            #gateway = "78.24.8.65";
        };
        ipv6 = {
            addresses = [{ 
                address = "2a00:1ed0:3c::dead:b00b"; 
                prefixLength = 64; 
            }];
        };
    };
    networking.networkmanager.insertNameservers = [
    #networking.nameservers = [
        "1.1.1.1"
        "8.8.8.8"
        "2001:4860:4860::1111" 
        "2606:4700:4700::8888" 
    ];
    networking.search = [ "vshosting.cz" ];
    networking.defaultGateway = { address = "78.24.8.65"; };
    networking.defaultGateway6 = { address = "2a00:1ed0:3c::1"; };

    networking.interfaces.enp3s0f0 = {
        ipv4.addresses = [ {
            address = "10.0.0.1";
            prefixLength = 24;
        }];
    };

}
