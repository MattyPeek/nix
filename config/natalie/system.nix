{ config, lib, pkgs, disko, ... }: {
    
    networking.hostName = "natalie";

    # System version
    system.stateVersion = "24.11";

    # Disable documentation to save up some time compiling
    documentation.enable = false;

    # GRUB
    boot.loader.grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        mirroredBoots = [{ 
            devices = [ "nodev"]; 
            path = "/boot"; 
        }];
    };
    
    # ZFS
    boot.supportedFilesystems = ["zfs"];
    #boot.zfs.requestEncryptionCredentials = true;
    boot.zfs.forceImportRoot = true;
    services.zfs.autoScrub.enable = true;
    networking.hostId = "86658b80"; # head -c 8 /etc/machine-id # for import/export to work
    
    # Kernel modules
    boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" "sr_mod" "amdgpu" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    # Plymouth
    boot.plymouth.enable = false;
    boot.plymouth.logo = pkgs.fetchurl {
        url = "https://nixos.org/logo/nixos-hires.png";
        sha256 = "1ivzgd7iz0i06y36p8m5w48fd8pjqwxhdaavc0pxs7w1g7mcy5si";
    };
    boot.plymouth.theme = "rings";
    boot.plymouth.themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
            selected_themes = [ "rings" ];
        })
    ];
    
    # Enable "Silent boot"
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
    boot.kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    boot.loader.timeout = 0; # Skip grub, click any key during boot to show

    # SmartCard support
    services.pcscd.enable = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];

    # Users
    users.users = {
        maty = {
            home = "/home/maty";
            isNormalUser = true;
            initialPassword = "brmbrm";
            description = "Matyas Pesek";
            extraGroups = [ "networkmanager" "wheel" "scard" "zrepl" ];
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

    };
    users.groups = {
        zrepl       =   { gid = 888; };
        transfer    =   { gid = 951; };
        postgres    =   { gid = 954; };
        wikijs      =   { gid = 962; };
        status      =   { gid = 963; };
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
    users.users.maty.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICnzRi2d8ONpPjM1VHWf1WngyG0UqAQ/BX8lXsyVUKct pesek@vshosting.cz"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDiISby1/6Axhrgyic8lzW32PHD3vZ5oDiwaobMVTDso maty@maty-lb"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6CDrn0fByLJ4+veIJbyCjUlHc/QbfiUpFMYmT1YJsR maty@mcbp"
        "command=\"zrepl stdinserver natalie\",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU4PkOUd+0KGcfbWAez5AjSyg9fvV4+Z1Z8yQxfoEw0 root@brokolice"
    ];

    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        #programs.gnupg.agent.pinentryPackage = {};
    };

    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (action.id == "org.debian.pcsc-lite.access_pcsc" && subject.isInGroup("wheel")) {
                return polkit.Result.YES;
            }
            if (action.id == "org.debian.pcsc-lite.access_card" && subject.isInGroup("wheel")) {
                return polkit.Result.YES;
            }
        });
    '';

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

    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';

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


    # Firewall
    #networking.firewall.enable = false;
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
