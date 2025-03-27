{ pkgs, config, lib, nixpkgs, modulesPath, inputs, disko, ... }: {

    disko.devices = {
        disk = {
            disk1 = {
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
                                mountpoint = "/boot/efi";
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
            disk2 = {
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
                        mountpoint = "/";
                    };
                    "system/root/home" = {
                        type = "zfs_fs";
                        mountpoint = "/home";
                    };
                    "system/root/var" = {
                        type = "zfs_fs";
                        mountpoint = "/var";
                    };
                    "system/root/srv" = {
                        type = "zfs_fs";
                        mountpoint = "/srv";
                    };
                    "nobackup/tmp" = {
                        type = "zfs_fs";
                        mountpoint = "/tmp";
                    };
                };
            };
        };
    };
}
