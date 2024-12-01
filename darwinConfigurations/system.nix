{ config, lib, pkgs, ... }: {
  security = {
    pam = {
      enableSudoTouchIdAuth = true;
    };
  };
  services = {
    nix-daemon = {
      enable = true;
    };
    sketchybar = {
      enable = false;
    };
  };
  system = {
    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
      };
      finder = {
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      loginwindow = {
        LoginwindowText = "brm brm";
      };
    };
    stateVersion = 5;
  };
  users = {
    users = {
      maty = {
        home = "/Users/maty";
      };
    };
  };
}
