{ config, lib, pkgs, ... }: {
    documentation = {
        enable = false;
    };
    security = {
        pam = {
            services.sudo_local.touchIdAuth = true;
            #enableSudoTouchIdAuth = true;
        };
    };
    services = {
        #nix-daemon = {
        #  enable = true;
        #};
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
      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true; # Use F1,F2,...
        "com.apple.mouse.tapBehavior" = 1; # Tap to click
        NSNavPanelExpandedStateForSaveMode = true; # Extended save dialog
        AppleShowAllExtensions = true; # File extesions
        _HIHideMenuBar = false; # Hide menubar
      };
      controlcenter.BatteryShowPercentage = true;
      controlcenter.Sound = true;
      controlcenter.Bluetooth = true;
      #hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
      hitoolbox.AppleFnUsageType = "Do Nothing";
    };
    keyboard = {
      remapCapsLockToEscape = true;
      swapLeftCtrlAndFn = false;
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };
    startup.chime = false;
    stateVersion = 5;
  };
  users = {
    users = {
      maty = {
        home = "/Users/maty";
      };
    };
  };
  programs.bash = {
    enable = true;
    completion.enable = true;
  };
}
