{ pkgs, config, inputs, ... }: {
    
    services.sketchybar = {
        enable = false;
    };
    
    services.nix-daemon.enable = true;

}
