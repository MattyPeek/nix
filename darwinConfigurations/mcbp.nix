{ inputs, ... }@flakeContext:
let
  darwinModule = { config, lib, pkgs, ... }: {
    config = {
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
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    darwinModule
    ./packages.nix
  ];
  system = "aarch64-darwin";
}
