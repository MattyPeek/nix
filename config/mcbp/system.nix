{ config, lib, pkgs, ... }: {
  documentation = {
    enable = false;
  };
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
      controlcenter.BatteryShowPercentage = true;
      controlcenter.Sound = true;
      controlcenter.Bluetooth = true;
      hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";
    };
    keyboard = {
      remapCapsLockToEscape = true;
      swapLeftCtrlAndFn = false;
      enableKeyMapping = true;
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
  programs.bash = {
    enable = true;
    completion.enable = true;
  };
}
