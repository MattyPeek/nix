# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:mattypeek/nix#natalie
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake ./#natalie

{ ... }: {

    disko.devices = {
        disk = {
            sda = {
                type = "disk";
                device = "/dev/sda";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "512M";
                            type = "EF00"; # EFI system partition
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        zfs = {
                            size = "100%";
                            content = {
                                type = "zfs";
                                pool = "pool1";
                            };
                        };
                    };
                };
            };
            sdb = {
                type = "disk";
                device = "/dev/sdb";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "512M";
                            type = "EF00"; # EFI system partition
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                #mountpoint = "/boot/efi";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        zfs = {
                            size = "100%";
                            content = {
                                type = "zfs";
                                pool = "pool1";
                            };
                        };
                    };
                };
            };
        };
        zpool = {
            pool1 = {
                type = "zpool";
                mode = "mirror";
                options.cachefile = "none";
                rootFsOptions = {
                    "compression" = "lz4";
                    "atime" = "off";
                };
                mountpoint = "/";
                postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^pool1@blank$' || zfs snapshot pool1@blank";
                
                datasets = {
                    "system/root" = {
                        type = "zfs_fs";
                        options.mountpoint = "/";
                    };
                    "system/root/home" = {
                        type = "zfs_fs";
                        options.mountpoint = "/home";
                    };
                    "system/root/var" = {
                        type = "zfs_fs";
                        options.mountpoint = "/var";
                    };
                    "system/root/srv" = {
                        type = "zfs_fs";
                        options.mountpoint = "/srv";
                    };
                    "nobackup/tmp" = {
                        type = "zfs_fs";
                        options.mountpoint = "/tmp";
                    };
                };
            };
        };
    };
}
