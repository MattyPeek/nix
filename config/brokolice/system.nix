{ config, lib, pkgs, ... }: {

    # System version
    system.stateVersion = "24.05";

    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

    # Disable documentation to save up some time compiling
    documentation.enable = false;

    # GRUB
    boot.loader.grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        mirroredBoots = [
            { devices = [ "nodev"]; path = "/boot"; }
        ];
    };

    # ZFS
    boot.supportedFilesystems = ["zfs"];
    boot.zfs.requestEncryptionCredentials = true;
    services.zfs.autoScrub.enable = true;
    networking.hostId = "15172c82"; # head -c 8 /etc/machine-id # for import/export to work
    #networking.hostId = "abfbceac"; # pmcllab

    # Users
    users.users = {
        maty = {
            home = "/home/maty";
            isNormalUser = true;
            initialPassword = "brmbrm";
            description = "Matyas Pesek";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [
                #thunderbird
            ];
        };
        transfer = {
            group = "transfer";
            home = "/srv/transfer";
            uid = 951;
        };
        postgres = {
            group = "postgres";
            home = "/srv/postgres";
            uid = 954;
        };
        wikijs = {
            group = "wikijs";
            home = "/srv/wikijs";
            uid = 962;
        };
        status = {
            group = "status";
            home = "/srv/status";
            uid = 963;
        };
        valheim = {
            group = "valheim";
            home = "/srv/valheim";
            uid = 964;
        };

    };
    users.groups = {
        transfer =  { gid = 951; };
        postgres =  { gid = 954; };
        wikijs =    { gid = 962; };
        status =    { gid = 963; };
        valheim =   { gid = 964; };
    };

    # Prompt for password change, if not already changed
    system.activationScripts.expirePasswordOnce = ''
        if id "maty" >/dev/null 2>&1; then
            if [ "$(chage -l maty | grep 'Last password change' | cut -d: -f2 | tr -d '[:space:]')" = "never" ]; then
                chage -d 0 maty
            fi
        fi
    '';

    # SSH
    services.openssh.enable = true;
    services.openssh.ports = [ 22 ];
    users.users.maty.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICnzRi2d8ONpPjM1VHWf1WngyG0UqAQ/BX8lXsyVUKct pesek@vshosting.cz"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiISby1/6Axhrgyic8lzW32PHD3vZ5oDiwaobMVTDso maty@maty-lb"
        "command=\"zrepl stdinserver natalie\",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBe3PgHQdmgwtmtmDO3Z9TOOjE/LHS8W6692L/UzzkiB"
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
        #enable = true; # depricated
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

    services.envfs.enable = true; # Mounts a FUSE filesystem on /bin

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

    # Hostname
    networking.hostName = "brokolice";

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
