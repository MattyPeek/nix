{ config, lib, pkgs, ... }: {
    services.openarena = {
        enable = true;
        extraFlags = [
            "+set dedicated 2"
            "+set sv_hostname 'NixOS OpenArena Server'"
            "+map oa_dm1"
        ];
    }
}
