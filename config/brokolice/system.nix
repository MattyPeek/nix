{ config, lib, pkgs, ... }: {
    
    # System version
    system.stateVersion = "24.05";
    
    # Disable documentation to save up some time compiling
    documentation.enable = false;

    # GRUB
    boot.loader.grub = { 
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
    };

    boot.supportedFilesystems = ["zfs"];
    boot.zfs.requestEncryptionCredentials = true;

    network.hostId = "15172c82"; # head -c 8 /etc/machine-id
  
    # Users
    users.users = {
        maty = {
            home = "/home/maty";
            isNormalUser = true;
            description = "Matyas Pesek";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [
                #thunderbird
            ];
        };
    };
    
    # SSH
    services.openssh.enable = true;
    users.users.maty.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICnzRi2d8ONpPjM1VHWf1WngyG0UqAQ/BX8lXsyVUKct pesek@vshosting.cz"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiISby1/6Axhrgyic8lzW32PHD3vZ5oDiwaobMVTDso maty@maty-lb"
    ];
    
    # SUDO
    security.sudo.enable = true;
    security.sudo.extraRules = [{
        groups = [ "wheel" ];
        users = [ "maty" ];
        commands = [{
            command = "ALL";
            options = [ "NOPASSWD" ];
        }];
    }];
    
    # Bash setup
    programs.bash = {
        enable = true;
        completion.enable = true;
    };
    environment.shellInit = ''
        # Load system-wide bashrc first
        if [ -f /etc/bashrc ]; then
          . /etc/bashrc
        fi

        # Load user-specific bashrc after
        if [ -f ~/.bashrc ]; then
          . ~/.bashrc
        fi
    '';

    # Docker
    virtualisation.docker.enable = true;

    # Network
    networking.networkmanager.enable = true;
    networking.interfaces.eth0.ipv4.addresses = [ {
        address = "192.168.51.10";
        prefixLength = 24;
    }];
    networking.defaultGateway = "192.168.51.1";
    networking.nameservers = [ 
        "1.1.1.1" 
        "8.8.8.8"
    ];

    # Firewall
    networking.firewall.enable = false;
    #networking.firewall.allowedTCPPorts = [ ... ];
    #networking.firewall.allowedUDPPorts = [ ... ];


    # Time and Locale
    time.timeZone = "Europe/Prague";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "cs_CZ.UTF-8";
        LC_IDENTIFICATION = "cs_CZ.UTF-8";
        LC_MEASUREMENT = "cs_CZ.UTF-8";
        LC_MONETARY = "cs_CZ.UTF-8";
        LC_NAME = "cs_CZ.UTF-8";
        LC_NUMERIC = "cs_CZ.UTF-8";
        LC_PAPER = "cs_CZ.UTF-8";
        LC_TELEPHONE = "cs_CZ.UTF-8";
        LC_TIME = "cs_CZ.UTF-8";
    };
    
}
