{ pkgs, ... }: {
    home.username = "maty";
    home.homeDirectory = "/Users/maty";    
    home.stateVersion = "25.05"; # Comment out for error with "latest" version
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        cowsay
    ];
}
