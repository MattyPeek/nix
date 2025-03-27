{ pkgs, lib, disko, ... }: {

    disko.devices = {
        disk = {
            main = {
                type = "disk";
                device = "/dev/disk/by-id/${builtins.head (lib.filterAttrs (name: val: val.type == "disk") (import <nixos/modules/installer/tools.nix>).availableDisks)}";
                content = {
                    type = "gpt";
                    partitions = {
                        boot = {
                            size = "1M";
                            type = "EF02"; # BIOS boot partition
                        };
                        esp = {
                            size = "512M";
                            type = "EF00"; # EFI system partition
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                            };
                        };
                        zfs = {
                            size = "100%";
                            content = {
                                type = "zfs";
                                pool = "rpool";
                            };
                        };
                    };
                };
            };
            mirror = {
                type = "disk";
                device = "/dev/disk/by-id/${builtins.head (lib.filterAttrs (name: val: val.type == "disk") (import <nixos/modules/installer/tools.nix>).availableDisks) ? 1}";
                content = diskoConfig.disk.main.content;
            };
        };
        zpool = {
            pool1 = {
                type = "zpool";
                mode = "mirror";
                rootFsOptions = {
                    "compression" = "lz4";
                    "atime" = "off";
                };
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
