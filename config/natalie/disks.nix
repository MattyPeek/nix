# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:mattypeek/nix#natalie
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake ./#natalie

{ lib, ... }: {

    disko.devices.disk = lib.genAttrs [ "sda" "sdb" ] (name: {
        type = "disk";
        device = "/dev/${name}";
        content = {
            type = "gpt";
            partitions = {
                ESP = {
                    size = "512M";
                    type = "EF00"; # EFI system partition
                    content = {
                        #type = "filesystem";
                        #format = "vfat";
                        #mountpoint = "/boot";
                        #mountOptions = [ "umask=0077" ];
                        type = "mdraid";
                        name = "efiraid";
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
    });
    
    disko.devices.mdadm = {
        efiraid = {
            type = "mdadm";
            level = 1;
            metadata = "1.0";
            content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
            };
        };
    };

    disko.devices.zpool = {
            pool1 = {
                type = "zpool";
                mode = "mirror";
                options.cachefile = "none";
                rootFsOptions = {
                    "compression" = "lz4";
                    "atime" = "off";
                    "mountpoint" = "none";
                    "acltype" = "posixacl";
                    "canmount" = "off";
                    "utf8only" = "off";
                    "normalization" = "none";
                    "xattr" = "sa";
                };
                postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^pool1@blank$' || zfs snapshot pool1@blank";
                
                datasets = {
                    "system" = {
                        type = "zfs_fs";
                        options.mountpoint = "none";
                    };
                    "nobackup" = {
                        type = "zfs_fs";
                        options.mountpoint = "none";
                    };
                    "system/root" = {
                        type = "zfs_fs";
                        options.mountpoint = "/";
                        mountpoint = "/";
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
}
