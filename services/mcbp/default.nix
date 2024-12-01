{ pkgs, config, inputs, ... }: {
    
    imports = with imputs; [
        nix-darwin.url = "github:LnL7/nix-darwin";
    ];

    services.sketchybar = {
        enable = false;
    };
    
    services.nix-daemon.enable = true;

}
