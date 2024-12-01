{ pkgs, config, inputs, ... }: {
    
    imports = with imputs; [
        nix-darwin.url = "github:LnL7/nix-darwin";
    ];

    system.defaults = {
      dock.autohide = true;
      dock.mru-spaces = false;
      loginwindow.LoginwindowText = "brm brm";
      finder.FXPreferredViewStyle = "Nlsv";
      finder.ShowToolbar = true;
      finder.ShowStatusBar = true;
      finder.ShowPathbar = true;
    };
    
    security.pam.enableSudoTouchIdAuth = true;
    
    # Set Git commit hash for darwin-version.
    system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;

}
