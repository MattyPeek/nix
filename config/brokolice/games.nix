{ config, lib, pkgs, ... }: {
    services.openarena = {
        enable = false;
        extraFlags = [
            "+set dedicated 2"
            "+set sv_hostname 'NixOS OpenArena Server'"
            "+map oa_dm1"
        ];
    }
}
